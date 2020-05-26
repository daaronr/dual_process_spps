## ----setup1, include=FALSE, warning=FALSE--------------------------------

local({
  r <- getOption("repos")
  r["CRAN"] <- "http://cran.r-project.org"
  options(repos = r)
})
library(knitr)
library(tidyverse)
library(here)
library(broom)
library(car)
library(citr)
library(cobalt)
library(coefplot)
library(data.table)
library(dataMaid)
library(estimatr)
library(furniture)
library(huxtable)
library(janitor)
library(lmtest)
library(glmnet)
library(pwr)
library(sandwich)
library(tufte)
library(kableExtra)
library(glue)
library(snakecase)
library(gmodels)
library(pscl)
library(margins)

# DescTools, blockTools, , , , , codebook, , , , dplyr, , experiment, forcats, ggsignif, glmnet, glmnetcr, glue, here, huxtable, janitor, kableExtra, knitr, , lubridate, magrittr, paramtest, plyr, purrr, purrr, pwr, pwr, randomizr, readxl, recipes, recipes, reporttools, rsample, sandwich, sjmisc, skimr, snakecase, statmod, statmod, summarytools, tidyverse

library(here)
here <- here::here
source(here("code", "functions.R"))

source(here::here("code", "baseoptions.R"))
library(ggsignif)

# install.packages("checkpoint")
# library(checkpoint)
# checkpoint("2019-05-21", checkpointLocation = tempdir()) #fixes packages as of this date for reproduceability


## ----import, include=FALSE, warning=FALSE, cache=FALSE-------------------

purl(here("analysis", "ImportData.Rmd"), output = here("code", "ImportData.R"))

source(here("code", "ImportData.R"))


## ----lists-or-vectors-of-variables, echo=TRUE, warning=FALSE, message=FALSE----

#ControlsFitme_nomood <- c(names(dplyr::select(sx_dp, sex:dimpairment, btwn_invite_dur, -birth, age, -starts_with("word"), -starts_with("eyes"), -contains("ctry2"), -contains("ctry3"))), "eyes_ correct_pct", "childpresentmdl", "clustergroup", "ordergroup", nbrnames, "happiness_1_beforeask", "student", "word_correct_pct")

#ControlsFitme <- c(ControlsEsxFitme_nomood, "mood_order_treat")
#ModeratorsEsxFitme <- ControlsEsxFitme # Same, but for 'honest' data mining work; Essex data only


## ----load recipes,warning=FALSE,message=FALSE----------------------------

# source(here("code","Recipes.R"))



## ----treatment-allocation, include=TRUE, paged.print=FALSE, warning=FALSE----

#pp("treatment allocations and balance")

(tab_treatalloc_sx_dp <- sx_dp %>%
  tabyl(treat_image, treat_eff_info) %>%
  tabylstuff_nocol(cap = "Image and effectiveness information treatments"))

pp("By 'river blindness first' charity ordering, effectiveness info, image treatment")
(tab_treatalloc_char_effect_image <- sx_dp %>%  tabyl(treat_image, treat_eff_info, d_river_1_st))

pp("By prior 'aid treatment', effectiveness info, image treatment")
(tab_treatalloc_aid_effect_image <-sx_dp %>%  tabyl(treat_image, treat_eff_info, aid_treat))



## ----Summary-stats-Donations_prelim, include=TRUE, paged.print=FALSE-----

sumstats_dp <- sx_dp %>% group_by(treat_eff_info, treat_image) %>%
 summarise(mn_don =mean(donation,na.rm=TRUE),
           d_donation = mean(as.numeric(d_donation), na.rm=TRUE),#this one looks a miscode
           mn_don_river =mean(don_river,na.rm=TRUE),
           d_don_river = mean(as.numeric(d_don_river),na.rm=TRUE),
           mn_don_gd =mean(don_guide_dogs,na.rm=TRUE),
            d_don_gd = mean(as.numeric(d_don_guide_dogs),na.rm=TRUE)) 

sumstats_dp %>% kable(digits = 1) %>% kable_styling()

cis_dp <- sx_dp %>%  group_by(treatment) %>% 
  summarise(n=n(),
            mean = ci(donation)[1], 
                      lowCI = ci(donation)[2],
                      hiCI = ci(donation)[3]
                      )
cis_dp %>%  kable(caption = "Mean/ci of donations by treatment combination, all data", digits=1) %>% kable_styling()


cis_dp_geocorrect <- sx_dp %>%  
  filter(attn_geog_qn=="Latin America and Africa") %>% 
  group_by(treatment) %>% 
  summarise(n=n(),
            mean = ci(donation)[1], 
                      lowCI = ci(donation)[2],
                      hiCI = ci(donation)[3]
                      )
cis_dp_geocorrect %>% kable(caption = "Mean/ci of donations by treatment combination, correct-geography answerers only", digits=1) %>% kable_styling()




## ----Summary-stats-Donations, include=TRUE, paged.print=FALSE------------

(tab_don <- sx_dp %>%
  tabyl(treat_image, donation) %>%
  tabylstuff_nocol("Donations by image treatment"))

(tab_don <- sx_dp %>%
  tabyl(treat_eff_info, donation) %>%
  tabylstuff_nocol("Donations by effectiveness treatment"))


## ----crosstab-Donations, include=TRUE, paged.print=FALSE-----------------

(tab_don_sum <- sx_dp %>% 
  sumtab2_func_plus(donation, treat_image, treat_eff_info,"Donation: positive % | mean, med--p75 | (sd) [N] "))

(tab_don_sum <- sx_dp %>% 
  sumtab2_func_plus(don_river, treat_image, treat_eff_info,"River-blindness donation: positive %, mean, med--p75 (sd) [N]"))

(tab_don_sum <- sx_dp %>% 
  sumtab2_func_plus(don_guide_dogs, treat_image, treat_eff_info,"Guide-dogs donation: positive %, mean, med--p75 (sd) [N]"))




## ----overallhist---------------------------------------------------------

ggplot(data=sx_dp, aes(sx_dp$donation)) +  geom_histogram()



## ----hist_by_treat_don---------------------------------------------------

plot_multi_histogram(sx_dp, "donation", "treat_image")
plot_multi_histogram(sx_dp, "donation", "treat_eff_info")



## ----hist_by_image_for_infotreat-----------------------------------------

plot_multi_histogram(filter(sx_dp, treat_eff_info=="Info"), "donation", "treat_image")



## ----hist_by_image_for_noinfotreat---------------------------------------

plot_multi_histogram(filter(sx_dp, treat_eff_info=="No info"), "donation", "treat_image")



## ----hist_by_treat_chars-------------------------------------------------

pp("...to guide dogs")
plot_multi_histogram(sx_dp, "don_guide_dogs", "treat_image")
plot_multi_histogram(sx_dp, "don_guide_dogs", "treat_eff_info")

pp("...  to river blindness")
plot_multi_histogram(sx_dp, "don_river", "treat_image")
plot_multi_histogram(sx_dp, "don_river", "treat_eff_info")



## ----Diagnostic-tests, include=TRUE--------------------------------------

sx_dp_shapiro <- shapiro.test(sx_dp$donation)



## ----Fisher-tests-incidence-chars, include=TRUE, warning=FALSE-----------

(rb_inc_by_eff <- sx_dp %>% tabyl(treat_eff_info, d_don_river) %>% 
  knitr::kable(caption = "River-blindness donation incidence by effectiveness info", digits = 0) %>%
  kable_styling())

(gd_inc_by_eff <- sx_dp  %>% tabyl(treat_eff_info, d_don_guide_dogs) %>% 
knitr::kable(caption = "Guide-dogs donation incidence by effectiveness info", digits = 0) %>%
  kable_styling())

(rb_inc_by_image <- sx_dp %>% tabyl(treat_image, d_don_river) %>% 
  knitr::kable(caption = "River-blindness donation incidence by effectiveness info", digits = 0) %>%
  kable_styling())

(gd_inc_by_eff <- sx_dp  %>% tabyl(treat_image, d_don_guide_dogs) %>% 
knitr::kable(caption = "Guide-dogs donation incidence by effectiveness info", digits = 0) %>%
  kable_styling())

FT_treat_eff_info_river <- fisher.bintest(d_don_river ~ treat_eff_info, sx_dp, alpha = 0.05, p.method = "fdr")
FT_treat_eff_info_gd <- fisher.bintest(d_don_guide_dogs ~ treat_eff_info, sx_dp, alpha = 0.05, p.method = "fdr")
FT_treat_image_river <- fisher.bintest(d_don_river ~ treat_image, sx_dp, alpha = 0.05, p.method = "fdr")
FT_treat_image_gd <- fisher.bintest(d_don_guide_dogs ~ treat_image, sx_dp, alpha = 0.05, p.method = "fdr")

FT_chars <- list(FT_treat_eff_info_river, FT_treat_eff_info_gd,FT_treat_image_river,FT_treat_image_gd)
FTnames <- c("Effectiveness: RB", "Effectiveness: GD", "Image: RB", "Image: GD")

FT_chars[[1]]$method <- "Fisher"
FT_chars[[2]]$method <- "Fisher"
FT_chars[[3]]$method <- "Fisher"
FT_chars[[4]]$method <- "Fisher"

FT_chars  <- map2(FT_chars, FTnames, function(x, y) {
  broom::tidy(x) %>% add_column(Experiment = y)
}) 

#todo: make this dplyr/tidy/pipey


  
FT_chars <- FT_chars%>%
  bind_rows() %>%
  kable(, caption = "Donation incidence by Image and Effectiveness-info treatments; Fisher tests", digits = 2) %>%
  kable_styling()

FT_chars



## ----Fisher-tests-donation-incidence, include=TRUE, warning=FALSE--------

options(digits = 3)

don_inc <- sx_dp %>% 
  group_by(treat_image, treat_eff_info) %>% 
  dplyr::summarize(donated = mean(as.numeric(d_donation))-1, don_gd = mean(as.numeric(d_don_guide_dogs))-1, don_river = mean(as.numeric(d_don_river))-1, n=n()) %>% 
  kable() %>%
  kable_styling()


#info

sx_dp %>% tabyl(treat_eff_info,d_donation) %>% 
knitr::kable(, caption = "Donation incidence by effectiveness info", digits = 0) %>%
  kable_styling()

FT_treat_info_only <- fisher.bintest(d_donation ~ treat_eff_info, filter(sx_dp,treat_image=="No image"), alpha = 0.05, p.method = "fdr")

FT_treat_add_info <- fisher.bintest(d_donation ~ treat_eff_info, filter(sx_dp,treat_image=="Image"), alpha = 0.05, p.method = "fdr")
 

FT_treat_eff_info <- fisher.bintest(d_donation ~ treat_eff_info, sx_dp, alpha = 0.05, p.method = "fdr")

FT <- list(FT_treat_info_only, FT_treat_add_info, FT_treat_eff_info)
FTnames <- c("Effectiveness vs control", "Effectiveness| Image present", "Effectiveness (pooled)")
FT <- map2(FT, FTnames, function(x, y) {
  broom::tidy(x) %>% add_column(Experiment = y)
}) 

FT[[1]]$method <- "Fisher"
FT[[2]]$method <- "Fisher"
FT[[3]]$method <- "Fisher"

FT <- FT %>% 
  bind_rows() %>%
  kable(, caption = "Donation incidence by Effectiveness-info treatments; Fisher tests", digits = 2) %>%
  kable_styling()

FT


## ----Fisher-tests-incidence, include=TRUE, warning=FALSE-----------------

sx_dp %>% tabyl(treat_eff_info, d_don_river) %>% 
  knitr::kable(caption = "River-blindness donation incidence by effectiveness info", digits = 0) %>%
  kable_styling()

sx_dp %>% tabyl(treat_eff_info, d_don_guide_dogs) %>% 
knitr::kable(caption = "Guide-dogs donation incidence by effectiveness info", digits = 0) %>%
  kable_styling()

FT_treat_eff_info_river <- fisher.bintest(d_don_river ~ treat_eff_info, sx_dp, alpha = 0.05, p.method = "fdr")
FT_treat_eff_info_gd <- fisher.bintest(d_don_guide_dogs ~ treat_eff_info, sx_dp, alpha = 0.05, p.method = "fdr")

FT_chars_ef <- list(FT_treat_eff_info_river, FT_treat_eff_info_gd)
FTnames <- c("Effectiveness: RB", "Effectiveness: GD")

FT_chars_ef  <- map2(FT_chars, FTnames, function(x, y) {
  broom::tidy(x) %>% add_column(Experiment = y)
}) 

#todo: make this dplyr/tidy/pipey

FT_chars_ef[[1]]$method <- "Fisher"
FT_chars_ef[[2]]$method <- "Fisher"
  
FT_chars_ef_k <- FT_chars_ef%>%
  bind_rows() %>%
  kable(, caption = "Donation incidence by Image and Effectiveness-info treatments; Fisher tests", digits = 2) %>%
  kable_styling()

FT_chars_ef_k



## ----treatment-differences--Statistical-tests-without-controls, include=TRUE, warning=FALSE----

# t-test Donations

pp("Defining treatment combinations here")

TreatCombinations <- split(combn(levels(sx_dp$treatment), 2), rep(1:ncol(combn(levels(sx_dp$treatment), 2)), each = nrow(combn(levels(sx_dp$treatment), 2)))) # get treatment combinations into a list of column vectors

pp("Key comparisons")




## ----Plots, out.width=c('50%', '50%'), fig.show='hold', include=TRUE, warning=FALSE----

# todo: sx_dp/EX/GT together?

#DotPlotsxcolours <- c( `No ask-Domestic` = "red2", `No ask-Internat.` = "blue3", )
#DotPlotsxshapes <- c( `No ask-Domestic` = 0, `No ask-Internat.` = 1, )

# (DotPlotsx17 <- sx_dp %>%
#   mutate(stage = as.numeric(stage)) %>%
#   filter(treatment != "No ask-Attrite", year == 2017) %>%
#   dotplot_func(donation, stage, treatment, "Essex 2017: mean donations by stage, treatment, attrition") +
#   scale_colour_manual(values = DotPlotsxcolours) +
#   scale_shape_manual(values = DotPlotsxshapes))



## ----boxplots, include=TRUE, warning=FALSE-------------------------------

(BoxPlots_dp_image<- sx_dp %>%
  boxplot_func_m(donation, treat_image, comparisons = list(c("Image", "No image"))) +
  ylab("Donation")) 

(BoxPlots_dp_info <- sx_dp %>%
  boxplot_func_m(donation, treat_eff_info, comparisons = list(c("Info", "No info"))) +
  ylab("Donation"))

(BoxPlots_dp <- sx_dp %>%
  boxplot_func_m(donation, treatment, comparisons = list(c("Control", "Image only"), c("Control", "Info only"), c("Control", "Image-Info"), c("Image only", "Image-Info"))) +
  ylab("Donation"))



## ----boxplotsgd, include=TRUE, warning=FALSE-----------------------------

(BoxPlots_dp_image_gd<- sx_dp %>%
  boxplot_func_m(don_guide_dogs, treat_image, comparisons = list(c("Image", "No image"))) +
  ylab("Donations: guide dogs"))

(BoxPlots_dp_info_gd <- sx_dp %>%
  boxplot_func_m(don_guide_dogs, treat_eff_info, comparisons = list(c("Info", "No info"))) +
  ylab("Donations: guide dogs"))

(BoxPlots_dp_gd <- sx_dp %>%
  boxplot_func_m(don_guide_dogs, treatment, comparisons = list(c("Control", "Image only"), c("Control", "Info only"), c("Control", "Image-Info"), c("Image only", "Image-Info"))) +
  ylab("Donations: guide dogs"))


## ----boxplotsrb, include=TRUE, warning=FALSE-----------------------------

pp("Donations to river blindness only")

(BoxPlots_dp_image_rb <- sx_dp %>%
  boxplot_func_m(don_river, treat_image, comparisons = list(c("Image", "No image"))) +
  ylab("Donations: river blindness"))

(BoxPlots_dp_info_rb <- sx_dp %>%
  boxplot_func_m(don_river, treat_eff_info, comparisons = list(c("Info", "No info"))) +
  ylab("Donations: river blindness"))

(BoxPlots_dp_rb <- sx_dp %>%
  boxplot_func_m(don_river, treatment, comparisons = list(c("Control", "Image only"), c("Control", "Info only"), c("Control", "Image-Info"), c("Image only", "Image-Info"))) +
  ylab("Donations: river blindness"))



## ----CDF Ask-vs-no-ask, eval = FALSE, echo = TRUE, warning=FALSE, fig.height=5,fig.align='center'----
## 
## #BELOW: code not evaluated (old)
## 
## # Todo: let's line these up side by side - 2017, 2019, pooled
## # PlotAskNoAsk <- sxB %>% ggplot(aes(donation, colour = treat_no_ask)) +
## #  stat_ecdf(geom = "step")
## 
## comparisons <- list(c("Asked", "No ask"))
## bpltDon_17 <- sx_dp %>%
##   filter(year == 2017, stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treat_no_ask, comparisons = comparisons) + ylab("Donation")
## bpltDon_17
## bpltDon_19 <- sx_dp %>%
##   filter(year == 2019, stage == "2", d_attrited == 0) %>%
##   boxplot_func_m(donation, treat_no_ask, comparisons = comparisons) +
##   ylab("Donation")
## bpltDon_19
## # ...ggboxplot(x = "treat_no_ask", y = "donation", color = "treat_no_ask", palette =c("#00AFBB", "#E7B800"), shape = "treat_no_ask") + stat_compare_means(label="t.test", comparisons = comparisons, method = "t.test")
## 
## bpltDon_17_19 <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treat_no_ask, comparisons = comparisons) + ylab("Donation")
## bpltDon_17_19
## #############################################
## 
## sx_dp$student <- fct_recode(sx_dp$student, "Student" = "1", "Non student" = "0")
## 
## bplt_facet_Don_17_19 <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   ggplot(aes(treat_no_ask, donation)) +
##   geom_boxplot() +
##   ylab("Donation") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   ) +
##   facet_grid(student ~ year)
## 
## pp("By year and (2017) student status")
## 
## bplt_facet_Don_17_19 <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   ggplot(aes(treat_no_ask, donation)) +
##   geom_boxplot() +
##   ylab("Donation") +
##   facet_grid(student ~ year) +
##   geom_signif(
##     comparisons = comparisons,
##     step_increase = c(.4), vjust = 1.7, margin_top = .7, textsize = 3
##   ) +
##   geom_signif(
##     comparisons = comparisons,
##     step_increase = c(.4), vjust = 0, margin_top = .7, textsize = 3, test = "t.test"
##   ) +
##   theme(
##     axis.title = element_text(size = 14),
##     axis.text = element_text(size = 14)
##   ) +
##   theme(axis.text.x = element_text(size = 12)) +
##   labs(title = "treatment", y = "donation", caption = "p-values of Wilcox-(below) and  t-test (above brackets)") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## bplt_facet_Don_17_19
## 
## pp("by time delay between asks")
## bplt_facet_start_Don_19t <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0, year == 2019) %>%
##   ggplot(aes(treat_no_ask, donation)) +
##   geom_boxplot() +
##   ylab("Donation") +
##   facet_grid(~ floor(btwn_invite_dur)) +
##   #  geom_signif(comparisons = comparisons,
##   #                step_increase = c(.4), vjust = 1.7, margin_top = .7, textsize = 3) +
##   #  geom_signif(comparisons = comparisons,
##   #              step_increase = c(.4), vjust = 0, margin_top = .7, textsize = 3, test = "t.test") +
##   theme(
##     axis.title = element_text(size = 14),
##     axis.text = element_text(size = 14)
##   ) +
##   theme(axis.text.x = element_text(size = 12)) +
##   labs(title = "treatment", y = "donation", caption = "p-values of Wilcox-(below) and  t-test (above brackets)") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## 
## bplt_facet_start_Don_19t
## 
## pp("by charity similarity")
## 
## bplt_facet_similarity_Don_sim <- sx_dp %>%
##   drop_na(treat_sim_dif) %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   ggplot(aes(treat_sim_dif, donation)) +
##   geom_boxplot() +
##   ylab("Donation") +
##   geom_signif(
##     comparisons = c(1, 2),
##     step_increase = c(.4), vjust = 1.7, margin_top = .7, textsize = 3
##   ) +
##   geom_signif(
##     comparisons = c(1, 2),
##     step_increase = c(.4), vjust = 0, margin_top = .7, textsize = 3, test = "t.test"
##   ) +
##   theme(
##     axis.title = element_text(size = 14),
##     axis.text = element_text(size = 14)
##   ) +
##   theme(axis.text.x = element_text(size = 12)) +
##   labs(title = "treatment", y = "donation", caption = "p-values of Wilcox-(below) and  t-test (above brackets)") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## 
## bplt_facet_similarity_Don_sim
## 
## pp("By charity similarity, total donations")
## bplt_facet_similarity_don_sim_tot <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   ggplot(aes(treat_sim_dif, total_don)) +
##   geom_boxplot() +
##   ylab("Total don") +
##   geom_signif(
##     comparisons = c(1, 2),
##     step_increase = c(.4), vjust = 1.7, margin_top = .7, textsize = 3
##   ) +
##   geom_signif(
##     comparisons = c(1, 2),
##     step_increase = c(.4), vjust = 0, margin_top = .7, textsize = 3, test = "t.test"
##   ) +
##   theme(
##     axis.title = element_text(size = 14),
##     axis.text = element_text(size = 14)
##   ) +
##   theme(axis.text.x = element_text(size = 12)) +
##   labs(title = "treatment", y = "Total don", caption = "p-values of Wilcox-(below) and  t-test (above brackets)") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## 
## bplt_facet_similarity_don_sim_tot


## ----fig-BoxPlotsx, eval = FALSE, fig.width = 10, fig.height = 5, fig.fullwidth = TRUE, message=FALSE, warning=FALSE----
## # todo: better ordering of treatments
## 
## box_charpairings_17 <- sx_dp %>%
##   filter(year == 2017, stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treatment, comparisons = list(c("No ask-Domestic", "Domestic-Domestic"), c("No ask-Internat.", "Internat.-Internat."))) +
##   ylab("Donation") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## box_charpairings_17
## 
## box_charpairings_19 <- sx_dp %>%
##   filter(year == 2019, stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treatment, comparisons = list(c("No ask-Domestic", "Domestic-Domestic"), c("No ask-Internat.", "Internat.-Internat."))) +
##   ylab("Donation") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## box_charpairings_19
## 
## box_charpairings_17_19 <- sx_dp %>%
##   filter(stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treatment, comparisons = list(c("No ask-Domestic", "Domestic-Domestic"), c("No ask-Internat.", "Internat.-Internat."))) +
##   ylab("Donation") +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   )
## 
## box_charpairings_17_19
## 
## box_similar_19 <- sx_dp %>%
##   filter(year == 2019, stage == "2", d_attrited == 0) %>%
##   boxplot_func(donation, treat_sim, comparisons = list(c("No ask", "Similar"), c("No ask", "Different"))) +
##   stat_summary(
##     fun.y = mean, geom = "point", shape = 18,
##     size = 3, color = "red"
##   ) +
##   ylab("Donation")
## box_similar_19


## ----recipe-working, eval = FALSE----------------------------------------
## 
## sxm <- sx_dp %>% select(donation, d_donation, total_don, firstasktreat, matches("treat|decision|btwn|dur|aid|EyesCorrectPct|^d_|country_birth|student|salaryrequest_1|ask|dur|educ|mom|dad|political|worth|respect|trust|risk|satisfaction|no_good|redist|private_redist|^uk|tax_share|children|birth_nation", -matches("seconds|sbeforeask|dur_survey.2|Duration (in seconds).2|lose|mx25|beforeask")),  to_snake_case(hroot_vars))
## 
## # sx_r <- recipes::recipe(donation+d_donation+total_don~., data = sxm) %>%
## #   step_meanimpute(all_numeric(), -all_outcomes()) %>%  step_knnimpute(all_nominal()) %>%  step_center(all_numeric(), -all_outcomes()) %>% step_scale(all_numeric(), -all_outcomes()) %>%  step_other(all_nominal()) %>% #all nominal variables with lt 5% ofgg obs --> other
## #   prep(training = sxm) %>%  recipes::bake(sxm)


## ----regular_regs_sxdp, eval=FALSE, include=TRUE-------------------------
## 
## # create design matrix
## # rec_donationSX in recipes.R
## 
## # suppressWarnings(try(sxprep <- prep(rec_donationSX, retain = TRUE) %>% juice()))
## 
## # trying out simple models-- cut?
## 
## model0 <- lm(donation ~ treat_image+treat_eff_info, data = sx_dp)
## model1 <- lm(donation ~ treat_image*treat_eff_info, data = sx_dp)
## model2 <- lm(don_guide_dogs ~  treat_image*treat_eff_info + d_river_1st, data = sx_dp)
## model3 <- lm(don_river ~  treat_image*treat_eff_info + d_river_1st, data = sx_dp)
## 
## hux_ols_don <- huxreg(model0,model1, model2, model3, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## hux_ols_don
## # todo - format this table with kable
## 
## IndepVars <- paste(ControlsAdhocEsx, collapse = " + ") %>%
##   paste("~", .)
## 
## ControlsAdhocEsx_dp <- c("sex", "age", "race", "P_Sympathetic_Warm", "essex_uni_student", "EyesCorrectPct", "V_benevolence", "V_universalism", "trust", "risk_willingness", "self_worth", "decision_mode", "mood_order_treat_1", "mood_order_treat")
## 
## # variables "childpresentmdl", "clustergroup"
## 
## IndepVars_s <- paste(ControlsAdhocEsxs, collapse = " + ") %>%
##   paste("~", .)
## 
## # Second stage total/incidence
## # Overall effect of first ask
## # Decision mode
## 
## ######################################################################
## 
## pp("Overall effect of first ask on second donation:")
## 
## ols_don_tr_noask <- lm(donation ~ treat_no_ask, data = sx_dp %>% filter(stage == "2"))
## ols_don_tr_noask_2017 <- lm(donation ~ treat_no_ask, data = sx_dp %>% filter(stage == "2" & year == 2017))
## ols_don_tr_noask_2019 <- lm(donation ~ treat_no_ask, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## hux_ols_don_tr_noask <- huxreg("Pooled" = ols_don_tr_noask, "2017" = ols_don_tr_noask_2017, "2019" = ols_don_tr_noask_2019, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## hux_ols_don_tr_noask
## 
## ols_dond_tr_noask <- lm(as.double(d_donation) ~ treat_no_ask, data = sx_dp %>% filter(stage == "2"))
## ols_dond_tr_noask_2017 <- lm(as.double(d_donation) ~ treat_no_ask, data = sx_dp %>% filter(stage == "2" & year == 2017))
## ols_dond_tr_noask_2019 <- lm(as.double(d_donation) ~ treat_no_ask, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## hux_ols_dond_tr_noask <- huxreg("Pooled" = ols_dond_tr_noask, "2017" = ols_dond_tr_noask_2017, "2019" = ols_dond_tr_noask_2019, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## 
## pp("Overall effect of first ask on second donation INCIDENCE:")
## 
## hux_ols_dond_tr_noask
## 
## pp("By SIMILARITY:")
## 
## ols_don_sim_noask <- lm(donation ~ treat_sim, data = sx_dp %>% filter(stage == "2"))
## ols_don_sim_noask_2017 <- lm(donation ~ treat_sim, data = sx_dp %>% filter(stage == "2" & year == 2017))
## ols_don_sim_noask_2019 <- lm(donation ~ treat_sim, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## hux_ols_don_sim_noask <- huxreg("Pooled" = ols_don_sim_noask, "2017" = ols_don_sim_noask_2017, "2019" = ols_don_sim_noask_2019, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## hux_ols_don_sim_noask
## 
## pp("Overall effect of first ask on TOTAL donation, by similarity")
## 
## ols_tdon_sim_noask <- lm(total_don ~ treat_sim, data = sx_dp %>% filter(stage == "2"))
## ols_tdon_sim_noask_2017 <- lm(total_don ~ treat_sim, data = sx_dp %>% filter(stage == "2" & year == 2017))
## ols_tdon_sim_noask_2019 <- lm(total_don ~ treat_sim, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## hux_ols_tdon_sim_noask <- huxreg("Pooled" = ols_tdon_sim_noask, "2017" = ols_tdon_sim_noask_2017, "2019" = ols_tdon_sim_noask_2019, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## hux_ols_tdon_sim_noask
## 
## 
## # Overall by time differential
## pp("# Overall by time differential")
## 
## ols_don_noaskXdur_2019 <- lm(donation ~ treat_no_ask * as.factor(round(btwn_invite_dur)), data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## hux_ols_don_noaskXdur_2019 <- huxreg(ols_don_noaskXdur_2019)
## # hux_ols_don_noaskXdur_2019
## 
## huxreg(ols_don_noaskXdur_2019, ci_level = .95, error_format = "[{conf.low}, {conf.high}]")
## 
## # Decision mode
## pp("Decision mode")
## 
## ols_don_noaskXdec_mode_2019 <- lm(donation ~ treat_no_ask * d_decis_intu, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## ols_don_simXdec_mode_2019 <- lm(donation ~ treat_sim * d_decis_intu, data = sx_dp %>% filter(stage == "2" & year == 2019))
## 
## huxreg(ols_don_noaskXdec_mode_2019, ols_don_simXdec_mode_2019)
## 
## 
## CrossReg <- cross2(DonOutVars, IndepVars_s) %>%
##   map(purrr::lift(paste)) %>%
##   unlist() # sets up linear model arguments for each of the DonOutVars
## 
## linreg <- function(relation) {
##   # regstr <- paste(DepVar, " ~ ", )
##   model <- lm(as.formula(relation), data = subset(sx_dp, stage == "2"))
##   model
## }
## 
## # try(models <- map(CrossReg, linreg)) # runs lm for each of "CrossReg" models
## # if you include the varls  "childpresentmdl", "clustergroup" --> Error in `contrasts<-`(`*tmp*`, value = contr.funs[1 + isOF[nn]]) :  contrasts can be applied only to factors with 2 or more levels
## # ... these (and all varls) need to be imputed where missing
## 
## sx_fixNA <- sx_dp %>% NA_preproc()
## 
## lik7_levels <- c("Disagree Strongly", "Disagree Moderately", "Disagree a little", "Neither agree nor disagre", "Agree a little", "Agree Moderately", "Agree Strongly")
## 
## # sx_fixNA <- sx_dp %>% NA_preproc()
## # sxcplt <- sx_fixNA[complete.cases(as.data.frame(sx_fixNA[ControlsEsxFitme])), ]
## 
## # NOTE: this is only a temporary solution -- we need to impute missings!
## 
## # ...first *with* treatment
## 
## # ...next *without* treatment, create quantiles to feed into Lee bounds


## ----Creating-matrix-of-robustness-checks-for-alternate-specifications--inclusion-criteria----

# Logistic regression
# S1.logist <- glm(S1.Contrib ~ relevel(Shares, ref="High") + GroupRelationship, family=binomial(link='logit'), data=d)
# summary(S1.logist)
# confint(S1.logist, level=0.95)
# anova(S1.logist, test="Chisq") #not sure what this part does


## ----honest-differentiation-nonlinearity---------------------------------

#' by personality attributes that previous literature find are associated with analytical versus emotional decision-making.

#' also bifurcate our estimates by these categories (gender, indicated religious affiliation vs. agnostic/atheist).'

# by students and nonstudents


## ----Mediation-analysis--------------------------------------------------



## ----ridge-and-preparation-for-Lee-bound-estimator, eval=FALSE, warning=FALSE, include=FALSE----
## 
## # Ridge following instructions from <https://drsimonj.svbtle.com/ridge-regression-with-glm_net>
## 
## # SXAH_r <- SXAH_r %>%
## #   select_if(function(x) !(all(is.na(x)) | all(x == ""))) %>%
## #   purrr::keep(is.numeric) # Drop non-numeric and always-missing
## # # rem: SXAH_r generated in Recipes.R
## 
## # SXAHnoatr <- SXAH_r %>% filter(!is.na(donation))
## # y <- SXAHnoatr %>%
## #   filter(!is.na(donation)) %>%
## #   select(donation) %>%
## # data.matrix()
## 
## # kitchen sink of pre-determined non-treatment variables
## x_df <- SXAHnoatr %>% dplyr::select(-one_of(sx_outcomes_ah), -one_of(sx_treatments_ah))
## x <- x_df %>% data.matrix()
## 
## lambdas <- 10^seq(3, -2, by = -.1)
## 
## library(glmnet)
## 
## pp("Having conformability issues here")
## 
## MSEs <- NULL
## for (i in 1:50) {
##   cv_fit <- cv.glmnet(x, y, alpha = 0, lambda = lambdas, standardize = TRUE, nfolds = 4)
##   MSEs <- cbind(MSEs, cv_fit$cvm)
## }
## # rownames(MSEs) <- cv_fit$lambda
## lambda.min <- as.numeric(names(which.min(rowMeans(MSEs))))
## 
## # todo: generate predictions for all obs (including attriters), put into quantile bins
## # opt_lambda <- cv_fit$lambda.min
## fit <- cv_fit$glmnet.fit
## y_predicted <- predict(fit, s = lambda.min, newx = x)
## sst <- sum((y - mean(y))^2)
## # sse <- sum((y_predicted - y)^2)
## # R squared
## # rsq <- 1 - sse / sst
## 
## print("(naive) rsq of CV ridge model:")
## # rsq
## 
## # generate predictions for all obs including attriters?
## x_all <- SXAH_r %>%
##   dplyr::select(-one_of(sx_outcomes_ah), -one_of(sx_treatments_ah)) %>%
##   data.matrix()
## y_predicted <- predict(fit, newdata = SXAH_r, s = lambda.min, newx = x_all)
## 
## # Putting back into a data frame to use in Lee
## xdf <- x_all %>% as.data.frame(as.table(.))
## y_predicted <- y_predicted %>% as.data.frame(.)
## colnames(y_predicted) <- c("y_predict") # not tidy
## SXAH_pr <- bind_cols(y_predicted, SXAH)
## 
## # Make quantiles of prediction, merge back into data to use in lee bounds
## SXAH_pr$Q10_y_predict <- CutQ(SXAH_pr$y_predict, breaks = quantile(SXAH_pr$y_predict, seq(0, 1, by = 0.1)))
## SXAH_pr$Q5_y_predict <- CutQ(SXAH_pr$y_predict, breaks = quantile(SXAH_pr$y_predict, seq(0, 1, by = 0.2)))
## 
## # DR: I can't get this to work with dplyr  ??mutate(percrank=rank(value)/length(value))
## 
## SXAH_pr_l <- SXAH_pr %>% dplyr::select("treatment", "treat_no_ask", "donation", "d_attrited", "stage", "student", "Q10_y_predict", "Q5_y_predict", "y_predict", "sex", "treat_second_ask_noa", "Treat_Int_Dom")


## ----lee-bound-estimation, eval=FALSE, warning=FALSE, include=FALSE------
## 
## # stata code
## if (Sys.info()["sysname"] == "Darwin") {
##   options("RStata.StataPath" = "/Applications/Stata/StataSE.app/Contents/MacOS/stata-se")
##   stataver <- 15
## } else {
##   options("RStata.StataPath" = "/usr/local/stata14/stata-se")
##   stataver <- 14
## }
## 
## p_load(RStata)
## # Todo: get these estimates to code a value for "NA's"
## 
## # this is our 'best' one; but I did fish it # stata(src = stata_leebound, data.in = sxdta, stata.version = stataver)
## 
## pp("students and nonstudents together;  deciles of predicted donations (from ridge) used to tighten Lee bounds:")
## 
## stata_leebound <- "leebounds donation treat_no_ask if stage == "2" , tight(Q10_y_predict) cie level(95)"
## stata(src = stata_leebound, data.in = SXAH_pr_l, stata.version = stataver)
## 
## pp("Same as above, bootstrapped:")
## stata_leebound <- "leebounds donation treat_no_ask if stage == "2" , tight(Q10_y_predict) cie level(95) vce(boot, reps(100))"
## stata(src = stata_leebound, data.in = SXAH_pr_l, stata.version = stataver)
## 
## pp("Compare to standard linear models, with and without the 2nd ask treatment dummy")
## 
## mod_s2_x <- lm(donation ~ treat_no_ask + y_predict * student + Q5_y_predict * student + treat_second_ask_noa * student, data = SXAH_pr_l)
## 
## mod_s2_x2 <- lm(donation ~ treatment + y_predict * student + Q5_y_predict * student, data = SXAH_pr_l)
## 
## huxreg(mod_s2_x, mod_s2_x2)
## 
## pp("Lee bounds, for students, as above (equivalent predicted outcome tighteners, for this sample)")
## SXAH_pr_l_s <- SXAH_pr_l %>% filter(student == "Student")
## SXAH_pr_l_s$Q10s_y_predict <- CutQ(SXAH_pr_l_s$y_predict, breaks = quantile(SXAH_pr_l_s$y_predict, seq(0, 1, by = 0.1)))
## 
## stata_leebound <- " leebounds donation treat_no_ask if stage == "2" , tight(Q10s_y_predict)  cie level(95)"
## stata(src = stata_leebound, data.in = SXAH_pr_l_s, stata.version = stataver)
## 
## pp("Compare to a standard linear model:")
## lm(donation ~ treat_no_ask + y_predict + Q10s_y_predict + treat_second_ask_noa, data = SXAH_pr_l_s) %>% huxreg()
## 
## pp("Lee bounds, for non-students, as above (equivalent predicted outcome tighteners, for this sample)")
## SXAH_pr_l_ns <- SXAH_pr_l %>% filter(student == "Non student")
## SXAH_pr_l_ns$Q5ns_y_predict <- CutQ(SXAH_pr_l_ns$y_predict, breaks = quantile(SXAH_pr_l_ns$y_predict, seq(0, 1, by = 0.2)))
## 
## stata_leebound <- " leebounds donation treat_no_ask if stage == "2" , tight(Q5ns_y_predict)  cie level(95)"
## stata(src = stata_leebound, data.in = SXAH_pr_l_ns, stata.version = stataver)
## 
## p_unload(RStata)
## 


## ----Additional-results-of-interest--------------------------------------



## ----donation-vs-omnibus-exploratory, eval = FALSE-----------------------
## 
## sx_dp %>%
##   filter(year == 2019, stage == "1") %>%
##   tabyl(schwartz_s_1_3) %>%
##   adorn_percentages("col") %>%
##   adorn_pct_formatting(digits = 2) %>%
##   adorn_ns() %>%
##   kable() %>%
##   kable_styling()
## 
## "Donations by Schwartz empathy"
## sx_dp %>%
##   filter(year == 2019, stage == "1", treat_no_ask == "Asked") %>%
##   dplyr::group_by(schwartz_s_1_3) %>%
##   dplyr::summarize(n(), mean(d_donation), mean(total_don), median(total_don), sd(total_don), mean(donation), sd(donation)) %>%
##   kable() %>%
##   kable_styling()
## 
## "Donated by trust"
## sx_dp %>%
##   filter(year == 2019, stage == "1", treat_no_ask == "Asked") %>%
##   tabyl(trust, d_donation) %>%
##   adorn_percentages("row") %>%
##   kable() %>%
##   kable_styling()
## 
## "Donations by trust - stage 1 and total"
## sx_dp %>%
##   filter(stage == "1", treat_no_ask == "Asked") %>%
##   dplyr::group_by(trust) %>%
##   dplyr::summarize(n(), mean(d_donation), mean(total_don), median(total_don), sd(total_don), mean(donation), sd(donation)) %>%
##   kable() %>%
##   kable_styling()
## 
## "Donations by trust (s2)"
## sx_dp %>%
##   filter(stage == "2") %>%
##   dplyr::group_by(trust) %>%
##   dplyr::select(donation, d_donation, total_don, trust) %>%
##   dplyr::summarise_all(funs(mean), na.rm = TRUE) %>%
##   kable() %>%
##   kable_styling()
## 
## "Donations by trust by dom-don vs int-int"
## sx_dp %>%
##   filter(stage == "1", treatment == "Internat.-Internat." | treatment == "Domestic-Domestic" | d_attrited == 1) %>%
##   dplyr::group_by(treatment, trust) %>%
##   dplyr::select(donation, d_donation, total_don, trust, treatment) %>%
##   dplyr::summarise_all(funs(mean), na.rm = TRUE) %>%
##   kable() %>%
##   kable_styling()
## 
## "Donated by decision mode, s1 2019)"
## sx_dp %>%
##   filter(year == 2019, stage == "1", treat_no_ask == "Asked") %>%
##   tabyl(decision_mode, d_donation)
## 
## "Donation by support dev poverty aid; s1, treat_first_ask International"
## sx_dp %>%
##   filter(stage == "1", treat_first_ask == "International") %>%
##   dplyr::group_by(dev_poverty_aid) %>%
##   dplyr::select(donation, d_donation, total_don, dev_poverty_aid) %>%
##   dplyr::summarise_all(funs(mean), na.rm = TRUE) %>%
##   kable() %>%
##   kable_styling()
## 
## "Donation by support domestic poverty aid; s1, treat_first_ask Domestic"
## sx_dp %>%
##   filter(stage == "1", treat_first_ask == "Domestic") %>%
##   dplyr::group_by(uk_poverty_aid) %>%
##   dplyr::select(donation, d_donation, total_don, uk_poverty_aid) %>%
##   dplyr::summarise_all(funs(mean), na.rm = TRUE) %>%
##   kable() %>%
##   kable_styling()


## ----outcomes_by_study, warning=FALSE------------------------------------

(out_by_study <- dp_sx_mt %>%
   mutate_if(is.character, as.factor) %>%
   mutate_if(is.logical, as.numeric) %>%
   table1(
     splitby = ~study,
          "DONATE" = d_donation, "Donation" = donation, "Don. Share" = av_don, 
          output = "html",
          na.rm = FALSE,
          test = FALSE,
          type = c("simple"),
          second = c("donation", "av_don"),
          total = TRUE
         ))



## ----regular_regs, warning=FALSE-----------------------------------------

sxmt_lin <- lm(donation ~ im05*eff05 + maxdon + as.factor(study), data = dp_sx_mt) %>%
coeftest(., vcov = vcovHC(., type = "HC0"))

sxmt_share <- lm(av_don ~ im05*eff05 + maxdon + as.factor(study), data = dp_sx_mt)  %>%
coeftest(., vcov = vcovHC(., type = "HC0"))

#fractional response 
sxmt_frac <- glm(av_don ~ im05*eff05 + maxdon + as.factor(study), data = dp_sx_mt, family = quasibinomial('logit'))

sxmt_fracm <- margins(sxmt_frac, data=dp_sx_mt,  type = "link")

sxmt_lpm <- lm(d_donation ~ im05*eff05 + maxdon + as.factor(study), data = dp_sx_mt) %>% 
coeftest(., vcov = vcovHC(., type = "HC0"))

hux_ols_don_sxmt <- huxreg('Amount' = sxmt_lin, 'Don share' = sxmt_share, '... frac.-response'=  sxmt_frac, 'DONATE-lpm' = sxmt_lpm, ci_level = .95, error_format = "[{conf.low}, {conf.high}]", coefs = c("(Intercept)","Image"="im05", "Effectiveness"="eff05", "Image x Eff." = "im05:eff05","Max pot'l don" = "maxdon"), statistics = c(N = "nobs", R2 = "r.squared"), note="{stars}. 95% CI's reported. Heteroskedasticity-robust (Huber-White) standard errors used.  Treatment variables and interactions (Image, Effectiveness, Image x Eff.) are effect-coded. Hidden controls in all columns: Study dummies. Fractional-response marginal effects given in footnote.")    %>% 
      set_caption('Regressions: pooled across studies 1-6') %>% 
        set_font_size(final(), 1, 9)                                   %>% 
          set_bottom_border(1, 1:2, 1)    %>%
        set_top_border(final(), 1, 1)                                  %>%
  theme_article %>%
 set_bold(final(), 1, FALSE)    

top_border(hux_ols_don_sxmt)[12, ] <- 1
bottom_border(hux_ols_don_sxmt)[12, ] <- 1
bottom_border(hux_ols_don_sxmt)[11, ] <- 1
width(hux_ols_don_sxmt) <- 1.6
number_format(hux_ols_don_sxmt) <- 2
col_width(hux_ols_don_sxmt) <- c(.75,.85,.9,.9,.9)
print_screen(hux_ols_don_sxmt)
hux_ols_don_sxmt


## ----lee-bounded---------------------------------------------------------

# stata code
if (Sys.info()["sysname"] == "Darwin") {
  options("RStata.StataPath" = "/Applications/Stata/StataSE.app/Contents/MacOS/stata-se")
  stataver <- 16
} else {
  options("RStata.StataPath" = "/usr/local/bin/stata15/stata-se")
  stataver <- 15
}

p_load(RStata)
# Todo: get these estimates to code a value for "NA's"

dp_sx_mt_stata <- dp_sx_mt %>%
  mutate(study=as.factor(study),
         don_pos_only = if_else(donation==0, na_dbl,donation),
         don_share_pos_only = if_else(av_don==0, na_dbl, av_don),
         ef_x_im = (im05>0)*(eff05>0)) %>%
  select(donation, don_pos_only, don_share_pos_only, im05, eff05, ef_x_im, maxdon, av_don, d_donation, study) %>%
    cbind(.,model.matrix( ~ study - 1, data=. )) %>% #study into dummies
  as.tibble()

#?, "parmest, fast"

leebounds_dpsx_im <- stata(src = c("leebounds don_share_pos_only im05, tight(eff05 study1 study2 study3 study4 study5) cie level(95) vce(boot, reps(100))"),
                   data.in = dp_sx_mt_stata, 
                   stata.version = stataver,
                   data.out = FALSE) 

leebounds_dpsx_ef <- stata(src = c("leebounds don_share_pos_only eff05, tight(im05 study1 study2 study3 study4 study5) cie level(95) vce(boot, reps(100))"),                   data.in = dp_sx_mt_stata, 
                   stata.version = stataver,
                   data.out = FALSE) 

dp_sx_mt_stata_nomis <- dp_sx_mt_stata %>%
  filter(!is.na(eff05), !is.na(im05))
  
# Interaction ... sort of... introducing eff wher IM present only 

leebounds_dpsx_inter <- stata(src = c("leebounds don_share_pos_only eff05, tight(study1 study2 study3 study4 study5) cie level(95) vce(boot, reps(100))"),                   data.in = filter(dp_sx_mt_stata_nomis, im05>0), 
                   stata.version = stataver,
                   data.out = FALSE) 

#leebounds_dpsx_im <- leebounds_dpsx_im  %>% 
 # mutate(stderr = paste0("(", round(stderr,2), ")"),
  #       estimate = round(estimate, 2),
   #      p = round(p, 3)) %>% 
  #unite(est, estimate, stderr, sep = " ") %>% select(Bound = parm, "Estimate" = est, "p-value" = p)

#huxtable(leebounds_dpsx) %>% add_colnames() %>% huxtable::add_footnote("Standard errors are given in parenthesis.", border =.8) %>% set_bold(1, 1:3, TRUE)


## ----sessinfo------------------------------------------------------------
sessionInfo()

