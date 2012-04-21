#!/bin/sh
lessc -x less/main.less > css/main.css &&\
coffee -o js -c coffee/* &&\
tar czf bin/timer.tgz index.html img wav css js &&\
echo 'success!'
