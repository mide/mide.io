update: clean check_for_link_rot build upload

build:
	bundle exec jekyll build

upload:
	bundle exec s3_website push

serve:
	bundle exec jekyll serve

check_for_link_rot:
	python3 check_for_link_rot.py

clean:
	rm -rf _site/ .sass-cache/
