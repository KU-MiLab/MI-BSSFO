% File Name: feature_extraction.m
% Author: Heung-Il Suk
% Cite: H.-I. Suk and S.-W. Lee, "A Novel Bayesian Framework for Discriminative 
% Feature Extraction in Brain-Computer Interfaces," IEEE Trans. on PAMI,
% 2012. (Accepted)

function features = feature_extraction( x_flt, CSP, BSSFO, verbose )
% x_flt: cell(2, numsamples) : 2-class
%           x_flt{1, i} = [nChannels, nSamples, nTrials]
%           x_flt{2, i} = [nChannels, nSamples, nTrials]
% CSP: cell(1, BSSFO.numBands) - trained spatial patterns in eachfrequency band

if verbose == 1
    fprintf( '\tFeature Extraction...\n\t\t' );
end

[nclass, nparticles] = size( x_flt );
features = cell( nclass, nparticles );

for i=1:BSSFO.numBands
    if verbose == 1
        if mod(i, 5) == 0
            fprintf( '%d', i );
        else
            fprintf( '.' );
        end
    end
    
    for k=1:nclass
        [nc, ns, nt] = size( x_flt{k, i} );
        temp = reshape( x_flt{k, i}, [nc, ns*nt] );
        temp = CSP{i}.W' * temp;
        temp = reshape( temp, [size(temp, 1), ns, nt] );
        temp = permute( temp, [2 1 3] );
        features{k, i} = squeeze( log(var(temp, 0, 1)) );
    end
end
fprintf( '\n' );