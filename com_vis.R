library(tidyverse)

map <- read_delim("sum.tsv", delim = "\t")
map.d <- map %>% mutate(sample = as.factor(sample)) %>% 
  mutate(sample = plyr::revalue(sample, c("c1" = "c14", "c2" = "c26", "c3" = "c29", "c4" = "c46")))
colnames(map.d) <- c("community", "description", "percent")
ggplot(map.d, aes(fill=community, y=percent, x=description)) + 
  geom_bar(position="dodge", stat="identity") + 
  scale_fill_viridis_d(option = "plasma") +
  theme_bw() +
  theme(axis.text.y=element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 15),
        axis.title.y=element_blank()) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE))