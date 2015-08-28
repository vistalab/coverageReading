load Gray/Checkers/retModel-Checkers.mat
mCheckers = model{1}; 

load Gray/Words/retModel-Words.mat
mWords = model{1}; 

load Gray/Original/retModel-CheckersMinusWords.mat
mCheckersMinusWords = model{1};


%% plotting x0
figure; 

subplot(4,1,1); 
hist(mCheckers.x0); 
title('Checkers x0')

subplot(4,1,2); 
hist(mWords.x0); 
title('Words x0')

subplot(4,1,3); 
hist(mCheckersMinusWords.x0)
title('CheckersMinusWords x0 - Model')

actualx0difference = mCheckers.x0 - mWords.x0; 
subplot(4,1,4)
hist(actualx0difference)
title('CheckersMinusWords x0 - Actual')

%% plotting y0
figure; 

subplot(4,1,1); 
hist(mCheckers.y0); 
title('Checkers y0')

subplot(4,1,2); 
hist(mWords.y0); 
title('Words y0')

subplot(4,1,3); 
hist(mCheckersMinusWords.y0)
title('CheckersMinusWords y0 - Model')

actualx0difference = mCheckers.y0 - mWords.y0; 
subplot(4,1,4)
hist(actualx0difference)
title('CheckersMinusWords y0 - Actual')


%% plotting Eccentricity
figure; 

subplot(4,1,1)
[thCheckers, radCheckers] = cart2pol(mCheckers.x0, mCheckers.y0);
hist(radCheckers)
title('Checkers ecc')

subplot(4,1,2)
[thWords, radWords] = cart2pol(mWords.x0, mWords.y0);
hist(radWords)
title('Words ecc')

subplot(4,1,3)
[thCheckersMinusWords, radCheckersMinusWords] = cart2pol(mCheckersMinusWords.x0, mCheckersMinusWords.y0);
hist(radCheckersMinusWords)
title('CheckersMinusWords ecc - model')

subplot(4,1,4)
radCheckersMinusWordsActual = radCheckers - radWords; 
hist(radCheckersMinusWordsActual)
title('CheckersMinusWords ecc - actual rad difference', 'FontWeight', 'Bold')




%% plotting polar angle (in radians)
figure; 

subplot(5,1,1)
hist(thCheckers)
title('Checkers pol')

subplot(5,1,2)
hist(thWords)
title('Words pol')

subplot(5,1,3)
hist(thCheckersMinusWords)
title('CheckersMinusWords Pol - model')

subplot(5,1,4)
thCheckersMinusWordsActual = thCheckers - thWords; 
hist(thCheckersMinusWordsActual)
title('CheckersMinusWords pol - actual pol difference')


subplot(5,1,5)
thCheckersMinusWordsActual_modPi = mod(thCheckersMinusWordsActual,pi); 
hist(thCheckersMinusWordsActual_modPi)
title('CheckersMinusWords pol - actual pol difference mod pi', 'fontweight', 'bold')

