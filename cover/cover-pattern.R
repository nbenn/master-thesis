library(singleCellFeatures)

data <- WellData(WellLocation("J107-2C", "H", 6))
data <- augmentImageLocation(data)

feat <- c("^Cells.Location_Center_X$",
          "^Cells.Location_Center_Y$",
          "^Cells.Location_Shifted_X$",
          "^Cells.Location_Shifted_Y$",
          "^Cells.Infection_IsInfected$",
          "^Cells.AreaShape_Area$",
          "^Cells.Intensity_MeanIntensity_CorrActin$")

data <- extractFeatures(data, select=feat)
data <- meltData(data)

data$mat$Cells$Binned <- cut_number(
  data$mat$Cells$Cells.Intensity_MeanIntensity_CorrActin, n=4)

pattern <- ggplot(data$mat$Cells, aes(x=Cells.Location_Shifted_X,
                           y=Cells.Location_Shifted_Y)) +
  geom_point(shape=21,
             aes(size=Cells.AreaShape_Area,
                 fill=factor(ifelse(
                   !data$mat$Cells$Cells.Infection_IsInfected,
                   NA,
                   data$mat$Cells$Binned)),
                 color=factor(data$mat$Cells$Binned))) +
  scale_fill_manual(values=c("#a6611a", "#dfc27d", "#80cdc1", "#018571"),
                    na.value=NA, guide="none") +
  scale_colour_manual(values=c("#a6611a", "#dfc27d", "#80cdc1", "#018571"),
                      guide="none") +
  scale_size_continuous(guide="none") +
  theme_bw() +
  theme(line=element_blank(),
        rect=element_blank(),
        strip.text=element_blank(),
        axis.text=element_blank(),
        plot.title=element_blank(),
        axis.title=element_blank())

ggsave(file="cover_pattern.svg", plot=pattern, width=14.55, height=10)
