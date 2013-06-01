ilp-applet
==========

This is a Java applet that sends a GAMS formulation describing one of several spatial architecture 
 to a host, and retrieves the result.
 
Uses code described in _A General Constraint-centric Scheduling Framework for Spatial Architectures_,
 a research paper published at PLDI 2013. It also uses examples described in a synthesis chapter (will 
 expand upon description).
 
###Issues
- The jarsigner method is flawed, and results in mixing both signed and unsigned code.
  - For development, edit Java settings to sidestep this restriction (Windows: control panel --> Java)
- The `<applet>` tag is no longer in the HTML standard, and browsers can remove it at will.
  - It still works, but the `<object>` tag is the overall correct one to use.

###Links
- [NEOS developer guide](http://www.neos-guide.org/content/java-developer-guide)
- [Example website](http://neos-dev-1.neos-server.org/guide/?q=node/27)
