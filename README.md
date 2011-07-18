Overview
--------

One of the things I do for me treasure is create custom web applications for SMBs, and often the client already has some infrastructure in place. Often times PHP is available, but sometimes they just have a basic hosting account on a windows box somewhere so the only language available is ASP. I’ve actually had a few gigs lately that needed somewhat complex sites, and they needed to be done is ASP.

I looked around for a framework for ASP. A nice, easy model / view / controller style framework for a bit of modularity, and I couldn't find anything. Since I will probably be getting more gigs like this, and I hate writing the same code twice, I decided to write my own simple framework. I have no idea if anyone who regularly uses ASP cares about this kind of stuff, but I figured I'd put it out there so people can at least have a base if they want (and at the minimum to document the framework for myself).

If you've used Mach-II, Struts, Fusebox, or RoR nothing in the framework will shock or amaze you. It's designed to be simple and easy with little configuration. Here is how it works.

Concept
-------

The basic concept is you create model objects in the _Model_ directory, you create view page(s) in the _View_ directory, and you link them together with a controller page in the, you guessed it, _Controller_ directory. There is no need to create a file anywhere except one of these 3 places, and there is no XML type control file.

A URL variable is passed into the framework that specifies the Controller and the Method to be called. The Controller page (which is *not* an object) does some work, creates any model objects it needs, and writes it's output to user defined variables in a Global Scope (more on this in a minute).

For a quick example, the URL _http://a.com/index.asp?C=Books.ShowBookForm_ would call the _ShowBookForm_ method defined in the _Books.asp_ controller. The Books controller can then create any objects and do anything it needs. It can then set it’s output to variables in Session(...) for the view page to display. Finally, it should set _Session("VIEW")_ to say what main view page should be used for display.

View
----

All the controller output is being written to the _Session_ scope, but the framework hijacks the _Session_ scope and turns it into a _Request_ scope.  At the end of the request the Session scope is destroyed, so the life cycle of the Session scope only lasts for the duration of the request.  I had to do this because it seems the Request scope in ASP is read only, and the Session scope is the only scope that persists through sub processes. (For session tracking I tend to use a database and cookies to manage the sessions anyway (I've found it helps with scalability)).

So on the view page, you can display any controller output by doing things like:

	<h1>Hello <%= Session("out.loggedInGuy") %></h1>

Where _out.loggedInGuy_ was set by the controller. You can also conditionally include other views (that can show Session(...) variables as well).  For example, the controller could set a variable to specify which include should be shown in the "main content" area of the page using _Utils.ShowView(view)_. Like so:

	<!-- #include file="../AppCore/Utils.asp" -->
	
	...
	
	<div class="mainToolbar"><%= Utils.ShowView("ToolBar.asp") %></div>
	<div><%= Utils.ShowView(Session("out.content")) %></div>
	<div class="mainRightSide"><%= Utils.ShowView("RightBar.asp") %></div>
	...

Controller
----------

The Model, in general, is a single class per file that does something, and the View is a typical ASP page with the Session(...) items put where you want the output to be displayed.  The controller is an ASP page that ties them together.  I couldn't figure out how to make them objects and work properly in the sub process (see the _Bit More Information_ section below), so I opted to define controller pages as switch pages (a la old school Fusebox).  An example controller page looks like the following - assume it's named LoginController.asp:

	<!-- #include file="../Model/Login.asp" -->
	<%
		Select Case Session("METHOD")
			Case "DoLogin"
				Dim MyLogin
				Set MyLogin = new Login
				MyLogin.DataFile = Session("SERVER_INSTALL_PATH") & "AppDatastorepasswords.dat"
				
				UserLevel = MyLogin.DoLogin(Request.Form("username"), Request.Form("password"))
				
				If(UserLevel = "ADMIN" Or UserLevel = "USER") Then
				    Session("out.content") = "Forms/Welcome.asp"
				Else
				    Session("login.error") = "The username or password passed was wrong!"
				    Session("out.content") = "Forms/Login.asp"
				End If
				
			Case "ShowLogin"
				Session("out.content") = "Forms/Login.asp"
				
		End Select
			
		Session("VIEW") = "Main"
	%>

Pretty straight forward.  It looks at the passed method, if it's the _DoLogin_ method it creates a Login object from the Model directory, and tries to login.  If it passes, it sets the pages user defined "main area" to a welcome screen, and if it fails, it sets it to the login form (and sets some display able text defined on the login form).

A URL to use the above controller would look like: _http://a.com/index.asp?C=LoginController.ShowLogin_, and then the form would post to _http://a.com/index.asp?C=LoginController.DoLogin_.

Speaking of form posts, one more _Utils_ method is _Utils.CreateLink(strController, strMethod)_. This does a bit of work for you when creating links or form postings by making a link to the proper controller / method.  For example, our login form that is processed above could look like this:

	<!-- #include file="../AppCore/Utils.asp" --> 

	<div class='error'>
	<%= Session("login.error") %>
	</div>

	<form name="login" action="<%= Utils.CreateLink("LoginController","DoLogin") %>" method="post">
	    User Name: <input type="text" name="username">
	    Password: <input type="password" name="password">
	    <input type="Submit" name="submit" value="Login">
	</form>

This keeps the form posting link from being hard coded, and allows the form to be reused in other applications. You could also set Session(...) variables for the controller and method parts of the CreateLink method if you were so inclined.

Main Parts
-----------

The main parts of the framework. AppCore/Settings.asp has stuff you may want to / need to change. Any new install should review that file and make sure it looks ok.

Here is a quick reference to the main parts of the framework:

|| Variable || Does ||
|-----------|---------|
| Session("CONTROLLER") | the controller portion from the url (information only) |
| Session("METHOD") | the method portion from the url (information only) |
| Session("VIEW") | the main view page to use for the request (controllers should set this) |
| Session("APP_DEBUG") | if the application is in debug mode (information only) |
| Session("INSTALL_PATH") | the path to the root of the application from the browsers point of view (information only) |
| Session("SERVER_INSTALL_PATH") | the path to the root of the application from the server file system point of view  (information only) |
| Session(strUserDefined) - any variables that the controller wants / should pass to the view |

|| Method || Does ||
|-----------|---------|
| <!-- #include file="AppCore/Utils.asp" --> | to get the Utils object |
| Utils.AddError(strErrorText) | add a processing error (for display on the error page) |
| Utils.ShowView(strViewPage) | a page in the View directory |
| Utils.CreateLink(strController, strMethod) | create a URL to the passed controller and method |

Bit More Information
---------------------

ASP is kind of unusual with includes. You can only include them with the _#include_ statement, and the file is included before it is compiled.  That means there is no way to conditionally include a file into the current request.  The only thing I found that comes close to a runtime include is the _Server.Execute()_ method.  However, this creates a sub process which makes it hard to / not possible to communicate with the parent process which is why I hijacked the _Session_ scope.

License
-------

I am using this framework for non-enterprise, but in need of modularity, ASP applications for SMB. This is not a project per se – it is just something I am using, and I thought others might benefit from it.

If you’d like to use it, you can download it and use it.  It is in the Public Domain.  As for installation, you should be able to just unzip them on your server and it should work out of the box.
