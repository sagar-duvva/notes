text_string = 'apple'
number_int = 10
decimal_float = -10.123
has_money_boolean = True
coordinates_tuple__cannot_change_after_creation = (2.5, 1.5, 1.0)
names_list_can_add_remove_elements = ['Agnetha', 'Bjorn', 'Benny', 'Anni']
unique_sets__cannot_contains_duplicate = {1, 2, 3, 4, 4, 5}
users_dictionary = {'sagar' : 35, 'lucky' : 35}
print(users_dictionary)
print(unique_sets__cannot_contains_duplicate)
print(names_list_can_add_remove_elements)


print(10 + 10)
number_number = 123
print(10 + number_number)

number_string = '1234' ## Now this is string instead of number
# print(10 + number_string) ## This will throw error saying unsupported types int(integer) and str(string) so we have to convert str -> int
## Using Type Constructor
print(10 + int(number_string)) ##converting string number_string into integer

string_number = 'ten'
# print(10 + int(string_number)) ## This will throw error saying invalid int(), as 'ten' is str but we are trying to convert it into int
print('10 ' + string_number) 