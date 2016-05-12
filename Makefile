update: clean check_for_link_rot build upload

build:
	echo "Building blog"
	jekyll build

upload:
	echo "Deploying blog to s3"
	s3_website push

check_for_link_rot:
	echo "Checking for link rot"
	python3 check_for_link_rot.py

clean:
	rm -rf _site/ .sass-cache/
