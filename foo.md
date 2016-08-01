This release marks a substantial achievement of elm-mdl: we have now ported _every_ component of Google's [Material Design Lite](https://getmdl.io/components/index.html)!

Live demo [here](https://debois.github.io/elm-mdl/), package [here](http://package.elm-lang.org/packages/debois/elm-mdl/7.0.0), github [here](https://github.com/debois/elm-mdl).

The release contains 6 new components: Cards, Lists, Dialog, Tabs, Sliders & Typography; a large amount of bugfixes, in particular wrt. browser compatibility; improved documentation; and substantial improvements to the demo. 

# Credits

- Rob van den Bogaard (@robvandenbogaard), new contributor. 
    Cards component. Rob created a very neat API for Cards, which in turn inspired the Dialog API. 

- Håkon Rossebø (@hakonrossebo), regular contributor.
    Lists component. Håkon paved the way for solving some thorny issues in finding a good API for lists, the upstream API of which doesn't sit so well with Elm. 

- Michael Perez (@puhrez), new contributor.
    Dialog component. Michael took Rob's Cards API-idea and ran with it, arriving at a very neat API for Dialogs. 

- Ville Penttinen (@vipentti), core contributor, commit-rights. 
    Tabs, Sliders, and Typography components; lots of demo work; lots of bugfixes. Ville provived a remarkbly high-quality sustained contribution.

- Alexander Foremny (@aforemny), core contributor, commit-rights.
    Bug fixes and improvements to menu. Alexander also participated crucially in discussions, taking a large part in guiding the overall direction of elm-mdl. 
    
- Stéphane Legrand (@slegrand), new contributor. 
    Bug-fixes for ripples, documentation improvements. 

- Søren Debois (@debois), original author. 
    Bug fixes galore; assisted on Cards, Lists, and Dialogs; lots of demo work.

Thanks to Google for making their JS/CSS MDL implementation available.

Supporting all components of Google's MDL is obviously a huge milestone for elm-mdl.  I could never have reached this point by myself; I'm so happy and grateful that so many people chose to devote their time and energy to this project.  So a _huge_ thank you to all of you who contributed to elm-mdl, to this release or earlier ones:

- Core team: Alexander Foremny (@aforemny), Ville Penttinen (@vipentti)
- Component implementations: Michael Perez (@puhrez), Rob van den Bogaard
  (@robvandenbogaard), Håkon Rossebø (@hakonrossebo)
- Demo work, features & bug-fixes: Victor Vrantchan (@groob), @SauceWaffle,
  Stéphane Legrand (@slegrand), Petre Damoc (@pdamoc)
- Documentation: Janis Voigtländer (@jvoigtlaender), Rudolf Adamkovič
  (@salutis), Alexey Shamrin (@shamrin), Matthew Bray (@mattjbray)

Also a big thank you to all those who are using elm-mdl; who has encouraged me in the elm-slack and on elm-discuss; and who has taken the trouble to open github issues: your kindness and encouragment has been a big part in getting to this point.  I want to mention in particular early adopter @groob and issue-author extraordinaire @OvermindDL1.

Thank you, all, for helping get elm-mdl this far!

Søren Debois
