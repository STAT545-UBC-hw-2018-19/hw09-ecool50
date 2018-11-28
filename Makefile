all: report.html PrefixReport.html

clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html Prefix.tsv Prefix_hist.png PrefixReport.md PrefixReport.html PrefixCloud.png
 
report.html: report.rmd histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: histogram.r words.txt
	Rscript $<

words.txt: /usr/share/dict/words
	cp $< $@

PrefixReport.html: PrefixReport.Rmd Prefix.tsv Prefix_hist.png PrefixCloud.png
	Rscript -e 'rmarkdown::render("$<")'

Prefix_hist.png: top_30_prefixes.tsv
	Rscript -e 'library(ggplot2); ggplot(data=read.delim("$<"), aes(x=value, y=freq)) + geom_bar(stat="identity")  + geom_col(fill = "red") + theme_dark() + labs(title = "Top 30 most common prefixes", x = "Prefix", y = "Frequency"); ggsave("$@")'
	rm Rplots.pdf

PrefixCloud.png: All_frequencies.tsv
	Rscript -e 'library(wordcloud); data = read.delim("$<"); png("PrefixCloud.png", width=8, height=8, units="in", res=300); wordcloud(words = data$$value, freq = data$$freq, min.freq = 50, random.order = F, colors = brewer.pal(8, "Dark2")); dev.off()'

All_frequencies.tsv: Prefix.R words.txt
	Rscript $<

Prefix.tsv: Prefix.R words.txt
	Rscript $<
