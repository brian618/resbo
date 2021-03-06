Chat bot written in Prolog used for food recommendations

Course project details with proposal here: [CPSC 312 Course Project](http://wiki.ubc.ca/Course:CPSC312-2017-Restaurant-Recommendation)

Types of queries we will support:
```prolog
ask([i,do,not,like,to,eat,seafood],Res,Food).
```
"Res" is variable for Restaurant
"Food" is variable for food that can be found in the restaurant.

Supported query formats:  
```
i [like/want] <food>.
i [like/want] to eat <food>.  
i do not [like/want] to eat <food>.
i [like/want] to eat <type> food.  
i do not [like/want] to eat <type> food.  
i [like/want] to eat <price> food.  
i do not [like/want] <price> food.
i [like/want] <food> [and/or] <food>.
i [like/want] to eat <food> [and/or] <food>.
i do not [like/want] <food> [and/or] <food>.
i do not [like/want] to eat <food> [and/or] <food>.

<food> includes: 
    burgers, fries, icecream, coffee, cookie, pizza, seafood, sushi, ramen
<type> includes:
    fast, cafe, western, japanese
<price_type> includes:
    cheap, moderate, expensive

an example query would be: (more examples can be found in query_example.pl)
    ?- ask([i,do,not,like,to,eat,japanese,food],Res,Food).
    Res = ['McDonalds'],
    Food = [burgers] ;
    Res = ['McDonalds'],
    Food = [fries] ;
    Res = ['McDonalds'],
    Food = [icecream] ;
    Res = ['Starbucks'],
    Food = [coffee] ;
    Res = ['Starbucks'],
    Food = [cookie] ;
    Res = ['Pizza Hut'],
    Food = [pizza] ;
    Res = ['Sage Bistro'],
    Food = [seafood] ;
    false.
```
The bot will list out the restaurant names and the food that they sell.

Also supports Dynamically modifying our knowledge base through user inputs:
```
<restraunt> now serves <food>.
<restraunt> no longer serves <food>.
<restraunt> has closed down.
<new restraunt> has opened.
```

We are assuming that all data entered into knowledge base from user during the session is true.
So if the user says that Pizza Hut serves burger then Pizza Hut will be added as a restaurant that sells burger.