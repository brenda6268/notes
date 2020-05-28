# django 国际化


wp_id: 707
Status: publish
Date: 2018-06-17 23:07:00
Modified: 2020-05-16 11:41:11


settings.py 中的设置：

```
MIDDLEWARE_CLASSES = (
    ...
    "django.middleware.locale.LocaleMiddleware",
)
 
 
LANGUAGE_CODE = "en"
TIME_ZONE = "UTC"
USE_I18N = True
USE_L10N = True
USE_TZ = True
 
LANGUAGES = (
    ("en", ("English")),
    ("zh-hans", ("中文简体")),
    ("zh-hant", ("中文繁體")),
)
 
#翻译文件所在目录，需要手工创建
LOCALE_PATHS = (
    os.path.join(BASE_DIR, "locale"),
)
 
TEMPLATE_CONTEXT_PROCESSORS = (
    ...
    "django.core.context_processors.i18n",
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