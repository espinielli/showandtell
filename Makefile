gifs = flows graphs bullets map

.PHONY: all html5
all: html5

html5: index.html

%.html: %.md css/espin.css espin.template.revealjs.html
	pandoc -t revealjs+link_attributes --template=espin.template.revealjs.html -s --mathjax \
		-V revealjs-url=/ --variable theme="sky" \
		--variable height=900 --variable width=1200 \
		--slide-level 2 \
		-o $@ $<

images/%-animated.gif:  media/%.mov
	ffmpeg -i $< -pix_fmt rgb8 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $@

media/%.mp4:  media/%.mov
	ffmpeg -y -i $< -r 16 -filter:v "setpts=0.25*PTS" -an $@


# NOTE ##################
# build this on request #
#########################
.PHONY: animatedgifs
animatedgifs: $(addsuffix -animated.gif,$(addprefix images/,$(gifs)))

# NOTE ##################
# build this on request #
#########################
.PHONY: mp4s
mp4s: $(addsuffix .mp4,$(addprefix media/,$(gifs)))


.PHONY: compress
compress: js/reveal.min.js

js/reveal.min.js: js/reveal.js
	uglifyjs --compress --mangle -o $@ -- $<
