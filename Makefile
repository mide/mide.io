build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve

upload: build
	bundle exec s3_website push

check_for_link_rot:
	python3 check_for_link_rot.py

clean:
	rm -rf _site/ .sass-cache/
