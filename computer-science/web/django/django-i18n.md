# django 国际化


ID: 707
Status: publish
Date: 2018-06-17 23:07:00
Modified: 2020-05-16 11:41:11


settings.py 中的设置：

```
MIDDLEWARE_CLASSES = (
    ...
    &#039;django.middleware.locale.LocaleMiddleware&#039;,
)
 
 
LANGUAGE_CODE = &#039;en&#039;
TIME_ZONE = &#039;UTC&#039;
USE_I18N = True
USE_L10N = True
USE_TZ = True
 
LANGUAGES = (
    (&#039;en&#039;, (&#039;English&#039;)),
    (&#039;zh-hans&#039;, (&#039;中文简体&#039;)),
    (&#039;zh-hant&#039;, (&#039;中文繁體&#039;)),
)
 
#翻译文件所在目录，需要手工创建
LOCALE_PATHS = (
    os.path.join(BASE_DIR, &#039;locale&#039;),
)
 
TEMPLATE_CONTEXT_PROCESSORS = (
    ...
    &quot;django.core.context_processors.i18n&quot;,
)
```

生成需要翻译的文件：

```
python manage.py makemessages -l zh_hans
python manage.py makemessages -l zh_hant
```

翻译其中的 django.po 文件，注意`.po`文件是一种通用的格式，有很多专门的编辑器

编译翻译好的文件

```
python manage.py compilemessages
```