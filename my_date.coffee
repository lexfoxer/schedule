'use strict'

# 
# Dictionarys
# 
dictionary_DayWeek = {
	'0': 'Воскресенье'
	'1': 'Понедельник'
	'2': 'Вторник'
	'3': 'Среда'
	'4': 'Четверг'
	'5': 'Пятница'
	'6': 'Суббота'
}

dictionary_ru_to_eng = {
	'января': 'jan'
	'февраля': 'feb'
	'марта': 'mar'
	'апреля': 'apr'
	'мая': 'may'
	'июня': 'jun'
	'июля': 'jul'
	'августа': 'aug'
	'сентября': 'sep'
	'октября': 'oct'
	'ноября': 'nov'
	'декабря': 'dec'
}

dictionary_Months = {
	'0': 'Января'
	'1': 'Февраля'
	'2': 'Марта'
	'3': 'Апреля'
	'4': 'Мая'
	'5': 'Июня'
	'6': 'Июля'
	'7': 'Августа'
	'8': 'Сентября'
	'9': 'Октября'
	'10': 'Ноября'
	'11': 'Декабря'
}

dictionary_TimeLessons = {
	'1': '8:30-10:00'
	'2': '10:10-11:40'
	'3': '11:50-13:20'
	'4': '13:50-15:20'
	'5': '15:30-17:00'
	'6': '17:10-18:40'
}


# 
# Generation time
# 

startWeek = new Date(2016, 7, 28, 0, 0, 0)	# указываем воскресенье -1 недели
startDay = new Date(2016, 8, 1, 0, 0, 0)	# Указываем 1 сентября учебного года

TZO = (new Date().getTimezoneOffset() * -1) * 1000 * 60		# отставание UTC в миллисекундах

getNumberLessonsWeek = (date, callback)->
	if isNaN(new Date(Date.parse(date)))
		callback '(getNumberLessonsWeek) Дата не верна: '+date

	start = (startWeek.getTime()) + TZO	# указываем первую неделю
	end = (new Date(date).getTime()) + TZO	# указываем входящую дату
	callback null, Math.ceil(((end - start) / (1000 * 60 * 60 * 24)) / 7)

toDate = (date, callback)->
	arr_date = date.split(' ')
	if dictionary_ru_to_eng[arr_date[1]] != undefined
		date = arr_date[0]+' '+dictionary_ru_to_eng[arr_date[1]]+' '+arr_date[2]
	if arr_date[2] == undefined
		date = arr_date[0]+' '+dictionary_ru_to_eng[arr_date[1]]+' 2016'

	if isNaN(new Date(Date.parse(date)))
		callback '(toDate) Дата не верна: '+date
	if new Date(date).getTime() < startDay.getTime()
		callback 'Дата не верна или позже начала учебного года: '+date

	new_date = new Date((new Date(date).getTime()) + TZO)
	day_week = new_date.getDay()
	code_week_fn = getNumberLessonsWeek new_date,(err, data)->
		if err
			throw err
		if day_week == 0
			return data-1
		return data

	callback null, {
		newDate: new_date			# полная дата (UTC + 3)
		dayWeek: day_week			# день недели (int)
		codeWeek: code_week_fn		# номер недели (int)
		evenWeek: code_week_fn%2	# четность недели
	}


module.exports = {
	int_week: getNumberLessonsWeek
	dic_date: dictionary_DayWeek
	dic_month: dictionary_Months
	dic_timeLessons: dictionary_TimeLessons
	to_date: toDate
}


