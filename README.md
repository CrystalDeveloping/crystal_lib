# crystal_lib
crystal_lib

# EXPORT

`exports['crystal_lib']:CRYSTAL().gridsystem({ 
   pos = vector3(0,0,0), -- posizione del marker
   rot = vector3(90.0, 90.0, 90.0), -- rotazione del marker
   scale = vector3(0.8, 0.8, 0.8), -- grandezza del marker
   textureName = 'marker', -- nome della texture del marker.ytd
   saltaggio = true, -- in questo modo il marker saltellerà
   permission = 'police', -- in questo caso solo la polizia potrà accedere al marker (se questa linea verrà cancellata tutti potranno accederci)
   job_grade = 2, -- in questo modo solamente il job police (settato subito sopra) con questo grado potra accedere al marker
   msg = 'Premi [E] per interagire', -- messagio che compare se sarai sopra al marker
   key = 38, -- in questo modo premendo E eseguira la funzione qui sotto (se questa linea non ci fosse, il tasto di default è 38 ovvero E)
   requestitem = 'nomeitem', -- se non volete questa cosa, togliete la riga
   action = function () -- funzione da eseguire se premuto il tasto settato
       print('ciao')
   end
})`

# DIPENDENZE

ES_EXTENDED

# Copyright
Copyright © 2024 CRYSTAL SCRIPTS This README file includes all the necessary sections: documentation link, requirements with hyperlinks, instructions for cloning the GitHub repository, an example of a FiveM script, and contact information. Feel free to modify any part as needed!
