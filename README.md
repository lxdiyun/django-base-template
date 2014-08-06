{% if False %}
# Django 1.6 Base Template #

## About ##

This template is based off of the work of [Mozilla Playdoh][playdoh] and
[Two Scoops of Django][twoscoops], as well as experience with other Django
layouts/project templates. Playdoh is mainly setup for Mozilla's systems and is
overly-complicated for a simple project template. (Though it does provide some
very good real-world use examples.)

This project template is designed for Django 1.4's new startproject template option. This version of the project template is designed for Django 1.6.

As much as I could, all the code has been updated to use the new suggested layout
and functionality in Django 1.6.

[playdoh]: https://github.com/mozilla/playdoh
[twoscoops]: https://github.com/twoscoops/django-twoscoops-project

## Features ##

By default, this project template includes:

A set of basic templates built from HTML5Boilerplate 4.1.0 and Twitter Bootstrap 3.0.2 (located in the
base app, with css and javascript loaded from CloudFlare CDN by default).

Templating:

- django_compressor for compressing javascript/css/less/sass

Security:

- bleach
- bcrypt - uses bcrypt for password hashing by default

Background Tasks:

- Celery

Migrations:

- South

Caching:

- python-memcached

Admin:

- Includes django-debug-toolbar for development and production (enabled for superusers)

Testing:

- nose and django-nose
- pylint, pep8, and coverage

Any of these options can added, modified, or removed as you like after creating your project.

## How to use this project template to create your project ##

- Create your working environment and virtualenv
- Make sure you have libffi installed ($ sudo apt-get install libffi-dev)
- Install Django 1.6 ($ pip install Django>=1.6)
- $ django-admin.py startproject --template https://github.com/lxdiyun/django-base-template/zipball/master --extension py,md,rst,ini,conf projectname
- $ cd projectname
- Uncomment your preferred database adapter in requirements/compiled.txt (MySQL, Postgresql, or skip this step to stick with SQLite)
- $ pip install -r requirements/local.txt
- $ cp projectname/settings/local-dist.py projectname/settings/local.py
- $ python manage.py syncdb
- $ python manage.py migrate
- $ python manage.py runserver

That's all you need to do to get the project ready for development. When you deploy your project into production, you should look into getting certain settings from environment variables or other external sources. (See SECRET_KEY for an example.)

There isn't a need to add settings/local.py to your source control, but there are multiple schools of thought on this. The method I use here is an example where each developer has their own settings/local.py with machine-specific settings. You will also need to create a version of settings/local.py for use in production that you will put into place with your deployment system (Fabric, chef, puppet, etc).

The second school of thought is that all settings should be versioned, so that as much of the code/settings as possible is the same across all developers and test/production servers. If you prefer this method, then make sure *all* necessary settings are properly set in settings/base.py, and then edit settings/__init__.py so it no longer reraises the exception. (ie, by replacing 'raise' with 'pass'). As it is, settings/local.py should only be overriding settings from settings/base.py anyway. (You could also just set the DJANGO_SETTINGS_MODULE environment variable to "{{ project_name }}.settings.base" directly.)

## Python 3 compatability ##

All the code provided in the template itself is compatable with Python 3. Unfortunately, there are still a number of libraries that do not work under Python 3. If you want to use this template under Python 3, you will need to either remove those libraries or find replacements for them.

The libraries I am aware of that do not support Python 3:

* django-compressor
* python-memcached (use python3-memcached)
* South has alpha support

## Special note ##

In the next version of this template (for Django 1.7), South will likely be removed. Django 1.7 is expected to ship with a native migration system which is heavily based upon and written by the author of South. For more information, see [the Django 1.7 development documentation][docs].

[docs]: https://docs.djangoproject.com/en/dev/topics/migrations/

## Nginx and uWSGI setup ##

All the examples settings is under folder production_settings
production_settings
|-- nginx_direct.conf
|-- nginx_proxy_80.conf
|-- nginx_proxy_8000.conf
|-- uwsgi.ini
`-- uwsgi_params

### uWSGI setup ###
Update file uwsgi.ini and uwsgi_params file if necessary, then copy uwsgi.ini to /etc/uwsgi/vassals. Restart the emperor.uwsgi services.

#### Nginx setup ####
If you want to server the django directly under the default 80 port vhost, use the config file nginx_direct.conf.
For example in nginx.conf:
```
user http http;
worker_processes  1;

error_log  /var/log/nginx/error.log;
...
http {
...
  server {
    listen       80;
    ...
    # copy or include nginx_proxy_80 here
    include path_to_nginx_direct.conf
  }
...
}
```
Or use ssl
```
user http http;
worker_processes  1;

error_log  /var/log/nginx/error.log;
...
http {
...
  server {
    listen       443 ssl;
    server_name  localhost;

    ssl_certificate      cert.crt;
    ssl_certificate_key  cert.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    root   /usr/share/nginx/html;
    location / {
        index  index.html index.htm index.php;

    # copy or include nginx_proxy_80 here
    include path_to_nginx_direct.conf
    }
  }
}
```
Or if you want to server the django behind some proxy, use the nginx_proxy_8000.conf file to server at 8000 port and then use nginx_proxy_80.conf to proxy pass the sub url to port 8000.
For example in nginx.conf:
```
user http http;
worker_processes  1;

error_log  /var/log/nginx/error.log;
...
http {
...
  server {
    listen       80;
    ...
    # copy or include nginx_proxy_80 here
    include path_to_nginx_proxy_80.conf
  }
  ...
  # copy or include nginx_proxy_8000 here, to start vhost under port 8000
  include path_to_nginx_proxy_8000.conf
}
```
Remeber to change the project folder permissions. Then restart the nginx. If all goning well, the project will server under
- http://server/{{ project_name }}
- https://server/{{ project_name }}
- http://server:8000/
- uwsgi file socket is under /tmp/{{ project_name }}.sock
Otherwise please check the error log of nginx and uwsgi to debug.

For troubles using sub url to server. Please pay attetion to SECRET_KEY settings in uwsgi_params, proxy_set_header and sub_filter settings in nginx config.
And install third party sub_filter module if necessary.
[docs]: http://wiki.nginx.org/HttpSubsModule

More information can be found in below documentation:
[docs]: http://uwsgi-docs.readthedocs.org/en/latest/tutorials/Django_and_nginx.html
[docs]: http://nginx.org/en/docs/http/ngx_http_core_module.html
[docs]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html
[docs]: http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html

{% endif %}
# The {{ project_name|title }} Project #

## About ##

Describe your project here.

## Prerequisites ##

- Python 2.6 or 2.7
- pip
- virtualenv (virtualenvwrapper is recommended for use during development)
- bower

## Installation ##

### javascript library setup ###
use bower to install javascript and css libraries needed by each app
- cd $project_dir/api/static/
- bower install
- cd $project_dir/api/api_demo/static/
- bower install


License
-------
This software is licensed under the [New BSD License][BSD]. For more
information, read the file ``LICENSE``.

[BSD]: http://opensource.org/licenses/BSD-3-Clause
