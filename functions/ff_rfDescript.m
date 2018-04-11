function rfDescript = ff_rfDescript(rfParams)
% rfDescript = ff_rfDescript(rfParams)
%
% Text description of rfParams for informative plotting purposes
% rfParams is from ff_rfParams

rfDescript = cell(7,1);
rfDescript{1} = ['rfParams'];
rfDescript{2} = ['x0    :    ' num2str(rfParams(1))];
rfDescript{3} = ['y0    :    ' num2str(rfParams(2))];
rfDescript{4} = ['sigEff:    ' num2str(rfParams(5))];
rfDescript{5} = ['theta :    ' num2str(rfParams(6))];
rfDescript{6} = ['bScale:    ' num2str(rfParams(9))];
rfDescript{7} = ['bShift:    ' num2str(rfParams(10))];

end