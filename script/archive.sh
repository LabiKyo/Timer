#!/bin/sh
lessc -x less/main.less > css/main.css &&\
coffee -o js -c coffee/* &&\
tar czf bin/timer.tgz application.html img audio css js &&\
echo 'success!'
