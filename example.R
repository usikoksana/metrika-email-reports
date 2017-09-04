library(xlsx) 
library(mailR)

setwd("D:/R") 

appToken <-"здесь должен быть токен" 

date1 <-format(Sys.Date()-1, "%Y-%m-%d") 
date2 <-format(Sys.Date()-1, "%Y-%m-%d")


counterID <-"здесь номер счетчика" 
metrics <-"ym:s:visits,ym:s:robotPercentage"
dimensions <-"ym:s:UTMSource"

api_request <-paste("https://api-metrika.yandex.ru/stat/v1/data.csv?id=",counterID,"&date1=",date1,"&date2=",date2,"&metrics=",metrics,"&dimensions=",dimensions,"&oauth_token=",appToken,sep="")
chem <-read.csv(file=api_request, encoding = "UTF-8")

filename <-paste("yandexbots_",date1,".xlsx",sep="")  

write.xlsx(chem, file=filename) 


textofbody <-paste ("Добрый день! Направляю отчетность по роботности за ", date1, sep="")
send.mail(from = "your_email@gmail.com",
          to = "example@gmail.com",
          subject = "Роботность",
          body = textofbody,
          encoding = "utf-8",
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "your_email@gmail.com", passwd = "здесь пароль", ssl = T),
          authenticate = TRUE,
          send = TRUE,
          attach.files = filename,
          file.names = filename, 
          debug = TRUE)
