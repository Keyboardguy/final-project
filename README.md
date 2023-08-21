# Menu for Canton House
#### Video Demo:  <URL HERE>
#### Description:

This is a restaraunt menu based off of a real restaraunt menu in Dundee. In this website, you can add and remove items from a basket, and the basket will automatically calculate the total cost for you. As well as this, you can search the menu and using AJAX, it will automatically display the menu items containing the query. It was based off the flask framework.

To run the website, type
'flask --app menu_package --debug run'

The static folder contains all the js and css. The js folders contain the code necessary for making the AJAX work, and it also attaches listeners whenever a new element is created, so that you can add and remove items to the session in the server.

All of the CSS here I wrote myself. I didn't use bootstrap because I felt that it confined me to a certain style, and the freedom of being able to design anything pretty much exactly the way I wanted felt promising. There is also a little bit of responsive web design, for the navbar changes from vertical to horizontal at a certain viewport width. As well as this, I debated adding more responsive features to the website. However, every change I added actually made it look worse.

The templates folder contains the html JINJA files. There is a base.html file which the other files inherit from. The basket.html and index.html just contain the skeleton for the website, and the query.html template is where the list of dishes is generated. The query.html template takes an array of dishes, and then takes all the information based off those dishes and turns into into a list of dishes. 

The db.py file holds all the information necessary for connecting to a database and handling commands. This was actually really hard, and I had to look up a guide for how to do this on the official flask website. I picked this instead of the cs50 database because I wanted to gain skills with a database outside of the cs50 course. In order to actually initialise the database and have show the changes you have made to the database, you need to run:

 'flask --app flaskr init-db'

 and it should come up with a message saying if the database has been initialized successfully.

 The menu.py file contains all of the routes and handles pretty much everything in the site server side. It is a blueprint, and it gets imported from the __init__.py file. Every time the user presses 'add' or 'delete' on a menu item, it actually sends a hidden post request to menu.py, which updates the session. It also returns extra information for the JS to use in order to display a new count of a dish, or a new total. 

 I made my own decorator inside the menu.py file because it avoided me reduplicating the code. Essentailly, the add and delete routes did nearly the same thing, but one deleted an item and one added an item. So I took out the common parts and turned them into a decorator, and applied it to both.

 The __init__.py file turns the folder it is in into a package. This is to make uploading and downloading the website easier, as you can import only this package with the website inside of it, and exclude other folders like tests and such. This file also sets up the flask website and bundles all of the files together into one nice website.

 The schema.sql contains the commands that are ran when you initialise the database with the command up above. You need to create the tables and their relationships, and add the data. 

 The venv is a virtual environment in python. It allows me to work with a specific version of flask and other modules that are imported, without worrying about what version of flask I have on my pc. 

 The instance folder contains the actual database created from the initialise command.

 The .gitignore file contains files for github to ignore pushing when I type 'git push'.

 The notes_for_self is self explanatory. It contains coding conventions that I'm using in the project so I don't mix them up.









