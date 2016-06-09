The following is the readme for the mobile systems and design project designed by Ravi Lonberg during Spring Semester 2016 for csci321: Mobile Systems Development.

Name: Ravi Lonberg
Working Product Title: Odds Desk
Description:

This project targets the audience of sports enthusiasts in any or all of the following major professional sports leagues: NBA, MLB, NHL, and FIFA. Aimed at delivering event times, mathups, and vegas odds for events in each of these leagues, this app takes a simplistic approach. The focus here is not to bog the user down with any unuseful information, instead delivering a clean and speedy interface that should be intuitive to the user and aesthetically pleasing.

Version 1.0 - Notes
	- limited number of leagues implemented (4)
	- backend error handling not in place for when server calls fail
	- api calls for larger leagues (FIFA) can take up to 4 or 5 seconds
	- live scores not implemented
	- Venmo API discontinued

Rubric Comments:

1. Product builds without warnings
2. Product runs on all devices. Note that constraints are not ideally set up for older products (i.e. iPhone 4, older iPads)
3. the 3.5 inch phone = iPhone 4 correct? Yes, product works for 3.5 inch
4. Product supports rotation
5. Methods & Classes are commented, no magic numbers

App Icon:
I designed my icon using Sketch (free trial). Still considering if I want to stick with this icon going forward, but I am happy with how it looks currently.

Reachability:
[implemented] - app checks for connection

Activity Indicators:
- should be viewable with every tabe load or refresh

Unit tests:
At the moment I have chosen not to implement unit tests. My application pulls from a perpetually changing XML server and thus all of my calculations are done on dynamically loaded data. Perhaps in the future I may choose to add unit tests to my date handler, but in all honesty: if my backend server goes down, my app goes down with it.

Git log:
A quick glance at my git log shows a lot of activity spread pretty evenly over the last several weeks. You may notice, however, that I did not make use of branch creation and merging. This was very intentional. Over the course of the semester, I have experienced some fairly nasty issues with XCode version control. One of such issues involved the creation of a new branch and merging it back into master, where I get corruption warnings of the sort: "bad XIB file". Another involves conflicts in the project.pbxproj file. I have found the the further I dive into attempting to resolve these issues the crazier it gets. For this reason, I chose to operate on one branch for this project and it actually worked out nicely.


Difficulties & Challenges:
XML parsing proved to be suprisingly difficult, as a result you may notice that I poured most of my effort into creating my downloaders. Considering that the XML feed I pull from changes every few seconds, I was required to build an incredibly stable and flexible downloader for each sport that wouldn't break when it encountered unexpected XML formatting. There are a great number of checks and guards in place to prevent app crashes and also to filter out unwanted or garabage XML information.

On the other side, I had a lot of fun designing my user interface. My aim here was to build something that looked clean and aesthically pleasing. You may notice that I have no text on my home screen and that was intentional. Furthermore, I did spend a good amount of time designing custom table cells for each league. Some of these cells even contain dynamically loaded pictures depending on event information.

At this point, everything works properly. I don't feel the need to direct you to any specific part of my project where I feel "most proud" but if you are curious, take a look at this site:

xml.pinnaclesports.com

... because that is the backend of my entire product. Basically I have transformed the information from the site above into a working iOS application.



