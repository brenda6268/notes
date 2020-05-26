# Puppeteer 中如何绕过无头浏览器检测


ID: 849
Status: publish
Date: 2019-12-20 11:52:36
Modified: 2020-05-16 10:45:54


执行以下代码：

```python
# credits: https://intoli.com/blog/making-chrome-headless-undetectable/

import pyppeteer as pp

from futile2.http import get_random_desktop_ua

HIDE_SCRIPTS = dict(
    hide_webdriver=&quot;&quot;&quot;
() =&gt; {
    Object.defineProperty(navigator, &#039;webdriver&#039;, {
      get: () =&gt; false,
    });
  }
&quot;&quot;&quot;,
    hide_navigator=&quot;&quot;&quot;
() =&gt; {
    // We can mock this in as much depth as we need for the test.
    window.navigator.chrome = {
      app: {
        isInstalled: false,
      },
      webstore: {
        onInstallStageChanged: {},
        onDownloadProgress: {},
      },
      runtime: {
        PlatformOs: {
          MAC: &#039;mac&#039;,
          WIN: &#039;win&#039;,
          ANDROID: &#039;android&#039;,
          CROS: &#039;cros&#039;,
          LINUX: &#039;linux&#039;,
          OPENBSD: &#039;openbsd&#039;,
        },
        PlatformArch: {
          ARM: &#039;arm&#039;,
          X86_32: &#039;x86-32&#039;,
          X86_64: &#039;x86-64&#039;,
        },
        PlatformNaclArch: {
          ARM: &#039;arm&#039;,
          X86_32: &#039;x86-32&#039;,
          X86_64: &#039;x86-64&#039;,
        },
        RequestUpdateCheckStatus: {
          THROTTLED: &#039;throttled&#039;,
          NO_UPDATE: &#039;no_update&#039;,
          UPDATE_AVAILABLE: &#039;update_available&#039;,
        },
        OnInstalledReason: {
          INSTALL: &#039;install&#039;,
          UPDATE: &#039;update&#039;,
          CHROME_UPDATE: &#039;chrome_update&#039;,
          SHARED_MODULE_UPDATE: &#039;shared_module_update&#039;,
        },
        OnRestartRequiredReason: {
          APP_UPDATE: &#039;app_update&#039;,
          OS_UPDATE: &#039;os_update&#039;,
          PERIODIC: &#039;periodic&#039;,
        },
      },
    };
  }
&quot;&quot;&quot;,
    hide_permission=&quot;&quot;&quot;
() =&gt; {
    const originalQuery = window.navigator.permissions.query;
    return window.navigator.permissions.query = (parameters) =&gt; (
      parameters.name === &#039;notifications&#039; ?
        Promise.resolve({ state: Notification.permission }) :
        originalQuery(parameters)
    );
  }
&quot;&quot;&quot;,
    hide_plugins_length=&quot;&quot;&quot;
() =&gt; {
    // Overwrite the &#x60;plugins&#x60; property to use a custom getter.
    Object.defineProperty(navigator, &#039;plugins&#039;, {
      // This just needs to have &#x60;length &gt; 0&#x60; for the current test,
      // but we could mock the plugins too if necessary.
      get: () =&gt; [1, 2, 3, 4, 5],
    });
  }
&quot;&quot;&quot;,
    hide_language=&quot;&quot;&quot;
() =&gt; {
    // Overwrite the &#x60;plugins&#x60; property to use a custom getter.
    Object.defineProperty(navigator, &#039;languages&#039;, {
      get: () =&gt; [&#039;en-US&#039;, &#039;en&#039;],
    });
  }
&quot;&quot;&quot;,
    hide_webgl_renderer=&quot;&quot;&quot;
() =&gt; {
    const getParameter = WebGLRenderingContext.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
      // UNMASKED_VENDOR_WEBGL
      if (parameter === 37445) {
        return &#039;Intel Open Source Technology Center&#039;;
      }
      // UNMASKED_RENDERER_WEBGL
      if (parameter === 37446) {
        return &#039;Mesa DRI Intel(R) Ivybridge Mobile &#039;;
      }

      return getParameter(parameter);
    };
}
&quot;&quot;&quot;,
    hide_broken_image=&quot;&quot;&quot;
() =&gt; {
    [&#039;height&#039;, &#039;width&#039;].forEach(property =&gt; {
      // store the existing descriptor
      const imageDescriptor = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, property);

      // redefine the property with a patched descriptor
      Object.defineProperty(HTMLImageElement.prototype, property, {
        ...imageDescriptor,
        get: function() {
          // return an arbitrary non-zero dimension if the image failed to load
          if (this.complete &amp;&amp; this.naturalHeight == 0) {
            return 20;
          }
          // otherwise, return the actual dimension
          return imageDescriptor.get.apply(this);
        },
      });
  });
}
&quot;&quot;&quot;,
    hide_modernizr=&quot;&quot;&quot;
() =&gt; {
    // store the existing descriptor
    const elementDescriptor = Object.getOwnPropertyDescriptor(HTMLElement.prototype, &#039;offsetHeight&#039;);

    // redefine the property with a patched descriptor
    Object.defineProperty(HTMLDivElement.prototype, &#039;offsetHeight&#039;, {
      ...elementDescriptor,
      get: function() {
        if (this.id === &#039;modernizr&#039;) {
            return 1;
        }
        return elementDescriptor.get.apply(this);
      },
    });
}
&quot;&quot;&quot;,
)


async def get_headless_page(*args, **kwargs):
    &quot;&quot;&quot;
    生成一个无法检测的浏览器页面
    &quot;&quot;&quot;
    browser = await pp.launch(*args, **kwargs)
    page = await browser.newPage()
    await page.setUserAgent(get_random_desktop_ua())
    for script in HIDE_SCRIPTS.values():
        await page.evaluateOnNewDocument(script)

    return page
```