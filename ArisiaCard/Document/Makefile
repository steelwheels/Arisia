#
#
#

main_doc_dir	= ../../Document/
main_image_dir	= $(main_doc_dir)/Images
this_image_dir	= ./Images

all: images

images: $(this_image_dir)/arisiacard-macos-screenshot.png \
	$(this_image_dir)/arisiacard-ios-screenshot.png

$(this_image_dir)/arisiacard-macos-screenshot.png: \
  $(main_image_dir)/arisiacard-macos-screenshot.png
	cp $< $@

$(this_image_dir)/arisiacard-ios-screenshot.png: \
  $(main_image_dir)/arisiacard-ios-screenshot.png
	cp $< $@

dummy:

