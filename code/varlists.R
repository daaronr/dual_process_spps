####################################
# LISTS OF VARIABLES  AND LABELS ###
# UPDATING to sx_dp -- needs a lot of work!
####################################

#####################
# OUTCOME VARIABLES #
#####################

DonOutVars <- c("donation", "d_donation", "total_don","char_choice") 

#TODO: add  transformed donation amount (shares?), add the version with attriters=0

HapOutVars <- c("Happiness") # Happiness outcomes

charity_attitudes <- c("")

out_vars_list <- c(DonOutVars,HapOutVars)

#######################
# TREATMENT VARIABLES #
#######################

AllDonTreatVars <- c("aid_treat","treat_eff_info","treat_image") # donation treatment categorizations
#add d_river_1st ... the reverse ordering thing

HapTreatVars <- c("mood_order_treat,mood_order_treat_1,mood_order_treat_2") # happiness treatment categorisations

####################### 
# MODERATOR VARIABLES #
#######################

mod_treat_vars <- c("d_decis_intu_m") #DP- add to this?
#- DPmod 
# variables (treatment and pre-determined) pre-registered for interaction with treatments

Moderators_Essex <- c("SEX", "essex_uni_student", "D_NoRelig", "risk_willingness", "decision_mode") # binary or categorical moderator variables (for impact of treatment on donations) 
#- DPmod 

#moderator_controls <- #these are necessary control variables for identification of moderating effects 

##################
# TIME SPAN  #####
##################

Timespan_Vars <- c("date_sent", "delay_response.1", "delay_response.2")
#-DPmod

##################
# RESPONSE TIMES #
##################

responsetimevars <- c("date_sent", "date_sent.2",  "delay_response.1", "delay_response.2")
#-DPmod

#############
# CONTROLS ##
#############

# Reasonable control variables in donation model based on ad-hoc/PaP; allow missing

ControlsAdhocEsx_nomood <- c("SEX", "age", "age_sq","RACE", "P_Sympathetic_Warm", "essex_uni_student", "EyesCorrectPct", "word_correct_pct", "V_benevolence", "V_universalism", "trust", "risk_willingness", "self_worth", "decision_mode", "childpresentmdl", "clustergroup")

ControlsAdhocEsx <- c(ControlsAdhocEsx_nomood, "mood_order_treat_1", "mood_order_treat")
#-DPmod
# todo: need to recover and use (something like , "happiness_beforeask", "happiness_1_beforeask" )

 
####################
# KEY DEMOGRAPHICS #
####################

# Key demographics, psychometrics, and treatment variations (todo)
# c("SEX","age","RACE", "RELIG","D_Muslim", "D_Christian", "D_NoRelig", "D_White", "P_Sympathetic_Warm","essex_uni_student", "EyesCorrectPct","V_benevolence", "V_universalism","trust","risk_willingness","self_worth","decision_mode")

#CTRSX <- ADSX %>% dplyr::select("essex_uni_student", "SEX", "RELIG", "childpresentmdl", "EyesCorrectPct", "trust", "mood_order_treat_1", "mood_order_treat")

#Used in assignments_power:

# nbrnames <- sx17 %>% ungroup() %>% dplyr::select(starts_with("nbr")) %>% names()

# ControlsEsxFitme_nomood <- c(names(dplyr::select(sx17, SEX:Dimpairment, btwn_invite_dur, -BIRTH, -starts_with("word"), -starts_with("EYES"), -contains("ctry2"), -contains("ctry3"))), "EyesCorrectPct", "childpresentmdl", "clustergroup", "ordergroup", nbrnames, "happiness_1_beforeask", "Student", "word_correct_pct")

# ControlsEsxFitme <- c(ControlsEsxFitme_nomood, "mood_order_treat")


######################
# VARIABLES LABELING #
######################

# Make FACTOR variables factors etc
factor_me <- c("RACE", "RELIG", "SINGLE", "SEX", "study_course", "previous_expt", "expt_pref", "_job", "_educ", "_birth", "mother_tongue", "other_langs", "lived_", "^kid_", "EYES", "^risk_", "trust", "decision_", "patience", "punish_", "polit_", "ideol_", "^pro_", "^happ", "s1happyfirst_dom_1", "^P_", "^V_", "^self_", "^word_")

# likerts <- c("^risk_", "trust", "decision_", "patience", "punish_", "polit_", "ideol_", "^pro_", "^happ", "s1happyfirst_dom_1", "^P_", "^V_", "^self_")

likerts <- c("worth","good_qualties","failure","comparison","proud","positive_attitude","satisfaction","respect","useless","no_good", "pol_interest","^risk_", "trust", "decision_", "patience", "punish_", "polit_", "ideol_", "^pro_", "^happ", "s1happyfirst_dom_1", "^P_", "^V_", "^self_","schwartz","get_ahead","topics","social_ideo","ineq", "redist","standard_live","private_redist","^dev","^uk","UK")

likertsm <- c("worth","good_qualties","failure","comparison","proud","positive_attitude","satisfaction","respect","useless")

likertsm5 <- c("ineq", "redist","standard_live","private_redist")

int_me <- c("^years_", "^eng", "stage")

bool_me <- c("^nbr_", "d_donation", "essex_uni_student", "^d_", "Student", "childpresentmdl", "Attrited")
# TODO -- give boolean variables a consistent format; code NA's as 0 where appropriate

ed_levels <- c(
  "Secondary Education (GCSE/O-Levels) or below", "Post-Secondary Education (College, A-Levels, NVQ3 or below, or similar)", "High School Degree", "Vocational Qualification (Diploma, Certificate, BTEC, NVQ 4 and above, or similar", "Some College", "Associates degree (Occupational, technical, or vocational program)", "Associates degree (Academic Program)", "Undergraduate Degree (BA, BSc etc.)", "Bachelor's Degree", "Master's Degree (MA, MS, MBA)", "Post-graduate Degree (MA, MSc etc.)",
  "Doctorate (PhD)"
)

lik7_levels <- c("Disagree Strongly", "Disagree Moderately", "Disagree a little", "Neither agree nor disagree", "Agree a little", "Agree Moderately", "Agree Strongly")

lik4_levels <- c("Strongly Disagree", "Disagree", "Agree", "Strongly Agree")

lik5_levels <- c("Strongly disagree" , "Disagree", "Neither agree nor disagree", "Agree", "Strongly agree")

ideol_levels <- c("Never justifiable", "2", "3", "4", "5", "6", "7", "8", "9", "Always Justifiable")

V_levels <- c("No Importance", "1", "2", "3", "4", "5", "6", "7", "Supreme Importance")

happy_levels <- c("Extremely unhappy", "Moderately unhappy", "Slightly unhappy", "Neither happy nor unhappy", "Slightly happy", "Moderately happy", "Extremely happy")

risk_levels <- c("Completely unwilling to take risks", "1", "2", "3", "4", "Risk Neutral", "6", "7", "8", "9", "Very willing to take risks")

patpun_levels <- c("completely unwilling to do so", "1", "2", "3", "4", "5", "6", "7", "8", "9", "very willing to do so")

polint_levels <- c("Very interested", "Somewhat interested", "Not very interested", "Not at all interested")
polit_levels <- c("Far Left", "2", "3", "4", "5", "6", "7", "8", "9", "Far Right")

proineq_levels <- c("Incomes should be made more equal", "1", "2", "3", "4", "5", "6", "7", "8", "9", "We need larger income differences as incentives for individual effort")

progovown_levels <- c("Government ownership of business and industry should be increased", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Private ownership of business and industry should be increased")

proluck_levels <- c("In the long run, hard work usually brings a better life", "2", "3", "4", "5", "6", "7", "8", "9", "Hard work doesnt generally bring success...")

taxshare_levels <- c("Much smaller share", "Smaller", "The same share", "Larger", "Much larger share")

ukaid_levels <- c("Spend less", "Spend the same amount", "Spend more")

importance_levels <- c("Not at all important", "Slightly important",  "Moderately important", "Very important", "Extremely important")

charity_impr_levels <- c("Very negative", "Somewhat negative", "Neutral or uncertain", "Somewhat positive", "Very positive")
##################################
# VARIABLES FOR BLOCKING H-ROOT ##
##################################

## Hroot 

hroot_vars <- c("age","SEX","RACE","D_english_firstlang","D_fluent_english","RELIG","STUDY","SINGLE","essex_uni_student","study_course","previous_expt","country_birth","expt_pref","country_birth") 

#Hroot Variables that merged with omni data:
hroot_vars_min <- c("D_uk_born","SEX","RACE","RELIG","STUDY","age","age_sq","SINGLE")

# ho_vars <- unique(c(hroot_vars, names(dplyr::select(sx17, SEX:Dimpairment,  -BIRTH, -starts_with("word"), -starts_with("EYES"), -contains("ctry2"), -contains("ctry3"), -starts_with("time"), -starts_with("Q1"), -starts_with("Q2"), -starts_with("winscreen"))), "age_sq","EyesCorrectPct", "word_correct_pct"))

# ho_vars_t <- unique(c(hroot_vars, names(dplyr::select(sx17, SEX:Dimpairment,-BIRTH,   RACE,num_siblings,-Dkids,-starts_with("word"), -starts_with("EYES"), -contains("ctry2"), -contains("ctry3"),-starts_with("time"),-starts_with("Q1"),-starts_with("Q2"), -starts_with("winscreen"))), "age_sq","EyesCorrectPct", "word_correct_pct"))

self_control_measures <- c("patience", "P_dependable_self_disciplined", "decision_mode") # Todo -- fix and factor these variables, impute at mean where missing (some variables for nonstudents only!)


###########
# MODELS ##
###########

#TODO: Probably add models here as formulas
