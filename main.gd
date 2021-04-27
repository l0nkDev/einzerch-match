extends Control

var regex = RegEx.new()
var usrnameurl = ""
var username_exists = false
var HighestScore = 0
var Matches = []
var BestMatch = "Placeholder"
var TempScore
var testDict = {"CompatibilityScore":0, "account_platform":1, "age":15, "color":2, "date":2, "food":2, "free_time_preference":2, "gender":2, "hobbie":5, "ideal_mate":1, "ig_handle":"aaaaaaaaaa", "relationship_values":1, "sexual_preference":1}
var my_data_comparison = {}
var current_page = 0
var ig_handle
var age = 18
var gender
var color
var hobbie
var free_time_preference
var ideal_mate
var relationship_value
var sexual_preference
var date
var food
var account_platform
var str_gender
var str_os
var sql_fetch_url = "" # SQL database json url
var sql_POST_url = ""  # SQL url to add rows
var database_response = []
var raw_json

func _ready():
	regex.compile("(?:@)([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\\.(?!\\.))){0,28}(?:[A-Za-z0-9_]))?)")
	if OS.has_feature('JavaScript') == false:
		$menu1/basic_info/question_1/TextureButton.queue_free()
	$intro_sequence/intro_anim.play("intro")

func _process(delta):
	if current_page == 1:
		if $menu1/basic_info/question_3/male_button.pressed == true and $menu1/basic_info/question_3/fem_button.pressed == true:
			sexual_preference = 3
		elif $menu1/basic_info/question_3/fem_button.pressed == true:
			sexual_preference = 1
		elif $menu1/basic_info/question_3/male_button.pressed == true:
			sexual_preference = 2
		if $menu1/basic_info/question_3/fem_button.pressed == false and $menu1/basic_info/question_3/male_button.pressed == false:
			sexual_preference = null
		if age != null and gender != null and sexual_preference != null and $menu1/basic_info/question_1/username.text.length() != 0:
			$menu1/next.disabled = false
		else: $menu1/next.disabled = true
	if current_page == 2:
		if color != null and date != null and hobbie != null and free_time_preference != null:
			$menu1/next.disabled = false
		else: $menu1/next.disabled = true
	if current_page == 3:
		if food != null and relationship_value != null and ideal_mate != null:
			$menu1/next.disabled = false
		else: $menu1/next.disabled = true

func offlinetest():
	current_page = 10
	$menu1/next.queue_free()
	$menu1/sending_screen.visible = true
	$menu1/animation.play("sending")
	pass

func intro_end():
	$intro_sequence.queue_free()

func _start():
#	$fetchpfpurl.request(String("https://www.instagram.com/l0nkGaemer777/"))
#	print('"')
	current_page = 1
	$menu1/animation.play("to_menu1")

func _back_pressed():
	if current_page == 3:
		current_page = 2
		$menu1/animation.play("from_menu3")
	elif current_page == 2:
		current_page = 1
		$menu1/animation.play("from_menu2")
	elif current_page == 1:
		current_page = 0
		$menu1/animation.play_backwards("to_menu1")

func _line_edit_pressed():
	if OS.has_feature('JavaScript'):
		username_exists = false
		find_node("username").text = JavaScript.eval("""
		window.prompt('Escribe tu nombre de usuario aqui (sin @)')
		""")
		var result = regex.search(String("@"+$menu1/basic_info/question_1/username.text))
		if $menu1/basic_info/question_1/username.text == "Null":
			$menu1/basic_info/question_1/checking.text = "¡Ingresa un nombre de usuario!"
			$menu1/basic_info/question_1/username.text = ""
			username_exists = false
		elif $menu1/basic_info/question_1/username.text.begins_with("@"):
			$menu1/basic_info/question_1/username.text = ""
			$menu1/basic_info/question_1/checking.text = "Por favor, no pongas @"
			username_exists = false
		elif result:
			print(result.get_string())
			print(String("@" + $menu1/basic_info/question_1/username.text))
			if result.get_string() == String("@" + $menu1/basic_info/question_1/username.text):
				username_exists = true
				$menu1/basic_info/question_1/checking.text = ""
			else: 
				$menu1/basic_info/question_1/checking.text = "Nombre de usuario invalido"
				$menu1/basic_info/question_1/username.text = ""
				username_exists = false
		ig_handle = $menu1/basic_info/question_1/username.text
#		usrnameurl = "https://www.instagram.com/" + ig_handle + "/"
#		print(usrnameurl)
#		$menu1/basic_info/question_1/checking.text = "Comprobando..."
#		$checkusername.request(usrnameurl)

func _minus_button():
	if age != 12:
		age = age - 1
		$menu1/basic_info/question_4/Label.text = str(age)

func _plus_button():
	if age != 18:
		age = age + 1
		$menu1/basic_info/question_4/Label.text = str(age)

func _test():
	pass


func _HTTPRequest_completed(result, response_code, headers, body):
	raw_json = String(body.get_string_from_utf8())
	var json = JSON.parse(body.get_string_from_utf8())
	database_response = (json.result)
	continueSend()

func _male_gender():
	gender = 1
	str_gender = "Masculino"

func _fem_gender():
	gender = 2
	str_gender = "Femenino"

func _nb_gender():
	gender = 3
	str_gender = "No binario"

func _send_button():
	offlinetest() #comment this line to connect to an online SQL database to fetch and add rows
	$HTTPRequest.request(sql_fetch_url)

func continueSend():
	ig_handle = $menu1/basic_info/question_1/username.text
	if $menu1/basic_info/question_3/male_button.pressed && $menu1/basic_info/question_3/fem_button.pressed == true:
		sexual_preference = 3
		str_os = "ambos"
	elif $menu1/basic_info/question_3/fem_button.pressed:
		sexual_preference = 1
		str_os = "mujeres"
	elif $menu1/basic_info/question_3/male_button.pressed:
		sexual_preference = 2
		str_os = "hombres"
	var my_data = {"ig_handle":ig_handle,"age":String(age),"gender":String(gender),"color":String(color),"hobbie":String(hobbie),"free_time_preference":String(free_time_preference),"ideal_mate":String(ideal_mate),"relationship_values":String(relationship_value),"sexual_preference":String(sexual_preference),"date":String(date),"food":String(food),"account_platform":"1"}
	my_data_comparison = {"ig_handle":ig_handle,"age":age,"gender":gender,"color":color,"hobbie":hobbie,"free_time_preference":free_time_preference,"ideal_mate":ideal_mate,"relationship_values":relationship_value,"sexual_preference":sexual_preference,"date":date,"food":food,"account_platform":"1"}
	print(my_data_comparison)
	var my_data_array = []
	my_data_array.append(my_data)
	var query = JSON.print(my_data_array)
#	print(query)
#	var headers = ["Content-Type: application/json"]
#	$HTTPRequest2.request(sql_POST_url, headers, false, HTTPClient.METHOD_POST, query)
#	print(sexual_preference)
	if OS.has_feature("JavaScript"):
		var code="""
			var xmlHttp = new XMLHttpRequest();
			xmlHttp.open( "POST", "http://einzerch.42web.io/json_receive.php", false );
			xmlHttp.send( '%s' );
			xmlHttp.responseText;""" % (JSON.print(my_data_array))
		JavaScript.eval(code)
	ematch()
	current_page = 10
	$menu1/next.queue_free()
	$menu1/sending_screen.visible = true
	$menu1/animation.play("sending")

func _next1():
	if current_page == 1:
		current_page = 2
		$menu1/next.disabled = true
		$menu1/animation.play("to_menu2")
	elif current_page == 2:
		current_page = 3
		$menu1/next.disabled = true
		$menu1/animation.play("to_menu3")
	elif current_page == 3:
		current_page = 4
		$menu1/next.disabled = true
		_send_button()

func _on_animation_animation_started(anim_name):
	$inputblocking.visible = true

func _on_animation_animation_finished(anim_name):
	$inputblocking.visible = false 

func _on_red_button_down():
	color = 1

func _on_green_button_down():
	color = 2

func _on_yellow_button_down():
	color = 3

func _on_purple_button_down():
	color = 4

func _on_orange_button_down():
	color = 5

func _on_pink_button_down():
	color = 6

func _on_black_button_down():
	color = 7

func _on_white_button_down():
	color = 8

func _on_celeste_button_down():
	color = 0

func _on_sports_button_down():
	hobbie = 1

func _on_music_button_down():
	hobbie = 2

func _on_playing_button_down():
	hobbie = 3

func _on_reading_button_down():
	hobbie = 4

func _on_netflix_button_down():
	hobbie = 5

func _on_stay_home_button_down():
	free_time_preference = 1

func _on_go_out_button_down():
	free_time_preference = 2

func _on_park_button_down():
	date = 1

func _on_cinema_button_down():
	date = 2

func _on_restaurant_button_down():
	date = 3

func _on_mall_button_down():
	date = 4

func _on_atracciones_button_down():
	date = 5

func _on_home_button_down():
	date = 6

func _on_hamburguesa_button_down():
	food = 1

func _on_pizza_button_down():
	food = 2

func _on_pasta_button_down():
	food = 3

func _on_sushi_button_down():
	food = 4

func _on_pollo_button_down():
	food = 5

func _on_ensalada_button_down():
	food = 6

func _on_leal_button_down():
	ideal_mate = 1

func _on_optimista_button_down():
	ideal_mate = 2

func _on_gracioso_button_down():
	ideal_mate = 3

func _on_bondadoso_button_down():
	ideal_mate = 4

func _on_amable_button_down():
	ideal_mate = 5

func _on_paciente_button_down():
	ideal_mate = 6

func _on_valiente_button_down():
	ideal_mate = 7

func _on_inteligente_button_down():
	ideal_mate = 8

func _on_carismatico_button_down():
	ideal_mate = 9

func _on_lealtad_button_down():
	relationship_value = 1

func _on_comunicacion_button_down():
	relationship_value = 2

func _on_sinceridad_button_down():
	relationship_value = 3

func _on_cario_button_down():
	relationship_value = 4

func _on_humor_button_down():
	relationship_value = 5

func ematch():
	for entry in database_response:
		entry["CompatibilityScore"] = 0
	for key in my_data_comparison.keys():
		if String(key) != "account_platform" and String(key) != "CompatibilityScore" and String(key) != "ig_handle" and String(key) != "gender" and String(key) != "sexual_preference":
			var value = my_data_comparison[key]
			for entry in database_response:
				if int(entry.age) >= age-2 and int(entry.age) <= age+2:
					print("desde los ",age-2)
					print ("hasta los ", age+2)
					if entry.gender == String(1) and int(sexual_preference) >= 2:
						if String(value) == String(entry.get(key)):
							entry.CompatibilityScore += 1
						if entry.CompatibilityScore >= HighestScore:
							HighestScore = entry.CompatibilityScore
					elif entry.gender == String(2) and int(sexual_preference) == 1:
						if String(value) == String(entry.get(key)):
							entry.CompatibilityScore += 1
						if entry.CompatibilityScore >= HighestScore:
							HighestScore = entry.CompatibilityScore
					elif entry.gender == String(2) and int(sexual_preference) == 3:
						if String(value) == String(entry.get(key)):
							entry.CompatibilityScore += 1
						if entry.CompatibilityScore >= HighestScore:
							HighestScore = entry.CompatibilityScore
					elif entry.gender == String(3):
						if String(value) == String(entry.get(key)):
							entry.CompatibilityScore += 1
						if entry.CompatibilityScore >= HighestScore:
							HighestScore = entry.CompatibilityScore
	for entry in database_response:
		print ("Compatibility = ", String(entry.CompatibilityScore))
		print("Highest = ", String(HighestScore))
		if entry.CompatibilityScore == HighestScore:
			Matches.append(entry.ig_handle)
			print(BestMatch," has the highest score")
	$menu1/sending_screen.visible = true
	BestMatch = String(Matches[randi() % Matches.size()])
	$menu1/sending_screen/s_username.text = "@" + BestMatch
	print("Best match is: ", BestMatch)
	print(Matches)

func urlreceived(result, response_code, headers, body):
	print(String(body.get_string_from_utf8()))
	$main_menu/test/Label.text = String(body.get_string_from_utf8())

func _on_TextureButton_button_down():
	OS.shell_open(String("https://www.instagram.com/" + BestMatch + "/"))
