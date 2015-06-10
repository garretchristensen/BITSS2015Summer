#Setting your working directory
setwd("C:/Users/Clara_2/Dropbox/Workshops/BITSS")
getwd()
dir()

#Brief intro: Data classes and vectors

#numeric vectors
y <- 1:12
z <- seq(from=5, to=13.2, length.out=12)
summary(y)

#Factor vectors
x <- c("apple", "pineapple","pineapple","banana","apple","pineapple")
x2 <- rep(x, 2)
x2f <- as.factor(x2)

#Extracting information from vectors by index
z[3]
x2f[5]

#indices can be a vector themselves, if you want to extract more than one thing.
seq(from=1, to=length(x2f), by=3)
z[seq(from=1, to=length(x2f), by=3)]

#Vectorization
z+2
y+z
nchar(x)

#Testing whether something is true. 
5 <10
"apple"=="apple" #DOUBLE == SIGN!!!!!
"pineapple" != "banana"

#Note that vectorization results in a LOGICAL VECTOR of TRUE and FALSE
z >= 8
y <= 10
x2f != "apple"

x2f %in% c("apple","pineapple")

#Extracting elements from a vector by testing a condition
z[z>=8]
x2f[x2f != "apple"]

#Note that conditions can be combined

z[z >= 8 & z < 11]
z[z >= 11 | z < 8]

x2f[x2f]

#Learning how to read in data files (Note syntax of assignment operaters)
ratings <- read.csv("ratings.csv")
states1 <- read.table("states1.csv", sep=",", header=TRUE)
read.delim("states2.csv", sep=",") -> states2
states3 <- read.csv("states3.csv")

#Learning how to inspect data files
head(ratings)
summary(ratings) 
summary(states1)
summary(states2)
summary(states3)
#Note difference between numeric and factor columns

#Merging data frames together
tmp <- merge(states1, states2, by="state.abb") #Save merged data set to temporary object
states <- tmp #Give temporary object a permanent name
tmp <- merge(states, states3, by.x="state.name", by.y="State" ) #Don't overwrite states just yet; make sure the merge works
states <- tmp #Now you can overwrite it, after checking that tmp came out properly

#Extracting information from a dataframe
ratings[1,5]#First row, fifth column
ratings[4,"meanWeightRating"]

#Both row and column specifications can be vectors
ratings[4:7, "meanWeightRating"]

#If both are vectors, you can get a baby dataframe
ratings[4:7, c(2,1)]
ratings[c(7,5,3), c("Word","Class")]

#Extracting subsets of dataframes by condition
ratings[ratings$Complex=="complex", "Word"]
ratings[ratings$Complex=="complex", c("Word", "Complex")]

#Getting the opposite of the condition
ratings[!ratings$Complex=="complex", c("Word", "Complex")]
ratings[ratings$Complex!="complex", c("Word", "Complex")]

#Extracting states with murder rates higher than 11.25
states[states$Murder > 11.25, "States"]

#Extracting information for California
states[states$state.name== "California", ]

#Finding the murder rates for the Pacific states with Incomes above 5000.
states[states$state.division=="Pacific" & states$Income > 5000, c("state.name","Murder")]

#Adding columns
states$state.area - states$Area
states$difAreas <- states$state.area - states$Area

mean(states$difAreas)

states$difFromMeanWrongness <- states$difAreas - mean(states$difAreas)

####Regression modeling and packages

install.packages(c("effects","lme4")) #only needs to be done once
library(effects) #Must be done every time you open R
library(lme4)

#getting package information
packageVersion("effects")
packageVersion("lme4")
sessionInfo()


#building models

mod1 <- lm(meanSizeRating ~ Frequency + Class + meanWeightRating + DerivEntropy, data=ratings) #Without interaction
mod2 <- lm(meanSizeRating ~ Frequency * Class + meanWeightRating + DerivEntropy, data=ratings) #With interaction
plot(allEffects(mod2))


#Performing a sequential AN(C)OVA
anova(mod2)


#Mixed effects

words <- read.csv("words.csv")
words$subject <- as.factor(words$subject)

mod.lmer <- lmer(RT ~ valence*subjAge + (1|subject) + (1|word), data=words)
mod2.lmer <- lmer(RT ~ valence*subjAge + (1|subject) + (1|word), data=words, REML=FALSE)
summary(mod.lmer)
plot(allEffects(mod.lmer))




#Let's play with a simulations to show the dangers of Type I error (falsely rejecting the null hypothesis)
set.seed(83)
x <- rnorm(n=500, mean=0, sd=1)
results <- shapiro.test(x)$p.value #Shapiro Wilke test takes as its null hypothesis that a sample IS normally distributed

plot(density(x), col="red")

x <- rnorm(n=500, mean=0, sd=1)
lines(density(x), col="green")
results <- c(results,shapiro.test(x)$p.value)


for (i in 1:500){
 x <- rnorm(n=500, mean=0, sd=1)
 results <- c(results, shapiro.test(x)$p.value)
 }

