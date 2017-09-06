
#!/bin/bash
echo "Submit markdwon files to Github."
hexo clean
git add .
git commit -m "zou-fnl"
git push origin hexo-files

