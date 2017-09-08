# metrika-email-reports

# Как настроить рассылку отчетов из Яндекс. Метрики с помощью R (с нуля) #

Яндекс.Метрика -  отличный инструмент для сбора данных о посещениях сайта, но, к сожалению, бывает так, что в веб-интерфейсе не хватает того или иного функционала – например, автоматической отправки отчета. В этой статье я подробно опишу, как получить статистику по роботности c помощью языка R.

Преимущества автоматической отправки отчетов:
+ Можно заранее настроить необходимый формат отчетов и не тратить время на выгрузки при приближении дедлайнов
+ Нет ограничений по формату и периодичности выгрузки


## 1. Установите язык R и необходимые библиотеки ##
**1.1.**	 Скачайте и установите [актуальную версию R](https://cran.r-project.org/bin/windows/base/), а также интегрированную среду разработки [R Studio](https://www.rstudio.com/products/rstudio/download/#download), в которой вам будет удобнее работать.


**1.2.**	 В R-Studio создаем новый файл и вставляем код:

	install.packages("xlsx")
	install.packages("mailR")
	install.packages("taskscheduleR")


**1.3.**	 Чтобы запустить процесс установки пакетов, выделите весь текст и нажмите «Run»

![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_1.png?raw=true)

## 2. Получите токен доступа к API Яндекс. Метрики ##
**2.1.**	Создаем приложение https://oauth.yandex.ru/client/new 
+ Права -> Яндекс.Метрика, выше выбираем «Получение статистики» и «создание счетчиков»
+ Callback URL -> выбираем “подставить URL для разработки»
+ Сохраняем 
 
![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_2.png?raw=true)

•	Получаем следующее:
 
![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_3.png?raw=true) 
 

**2.2.**	Идем по ссылке: https://oauth.yandex.ru/authorize?response_type=token&client_id=<идентификатор приложения>
Где вместо <идентификатора>  подставляем свое  значение ID


**2.3.**	Даем разрешение:

![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_4.png?raw=true)
 

**2.4.**	Копируем и сохраняем токен:
 
![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_5.png?raw=true)


## 3. Настраиваем автоматическую отправку отчета ##
**3.1.**	Вставляем код в R-Studio:

Меняем: setwd, appToken, counterID, почту получателя, свою почту и пароль

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

 *Если R-Studio ругается на xlsx, то идем по ссылке и скачиваем соответствующую версию java https://www.java.com/en/download/manual.jsp 
** доступные метрики и группировки - [можно посмотреть здесь](https://tech.yandex.ru/metrika/doc/api2/api_v1/attributes/visits/behavior-docpage/)

**3.2.**	Идем в свой аккаунт Gmail и даем разрешение на взаимодействие с «ненадежными приложениями»  (иначе письмо не отправится) 
https://myaccount.google.com/u/4/security?hl=ru&pageId=none#connectedapps 

![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_6.png?raw=true)


**3.3.**	Настраиваем расписание отправки:

![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_7.png?raw=true)

![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_8.png?raw=true)


**3.4** Проверяем планировщик заданий (Панель управления ->Расписание выполнения задач)
 Если задание есть, но письмо не отправляется - открываем свойства задания, вкладку «Действия» -> Изменить
 И ставим 1 в конце строки 
 
![](https://github.com/usikoksana/metrika-email-reports/blob/master/r_9.png?raw=true)
