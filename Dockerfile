FROM jekyll/jekyll:3.5

COPY --chown=jekyll:jekyll . /srv/jekyll
RUN chown jekyll:jekyll /srv/jekyll && chmod 0755 /srv/jekyll
RUN mkdir -p /var/www/site && chown -R jekyll:jekyll /var/www/site && chmod -R 0755 /var/www/site
#USER root
RUN bundle install
#RUN JEKYLL_ENV=production PAGES_REPO_NWO=heptio/ark bundle exec jekyll build -d /var/www/site --verbose
RUN JEKYLL_ENV=production bundle exec jekyll build -d /var/www/site --verbose

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/site.conf
COPY --from=0 /var/www/site/ /usr/share/nginx/html/
RUN rm /usr/share/nginx/html/nginx.conf     ## Avoid including this in previous stage
