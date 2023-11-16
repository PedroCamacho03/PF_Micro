% Configura a porta serial
s = serial('COM3', 'BaudRate', 9600); % Use a porta correta
fopen(s);

% Inicializa os vetores de dados e os gráficos
maxSamples = 100; % Número máximo de amostras a serem exibidas
dataIluminancia = zeros(1, maxSamples);
dataUV = zeros(1, maxSamples);

% Inicializa os gráficos
figure;

subplot(2, 1, 1);
hIluminancia = plot(dataIluminancia);
xlabel('Amostras');
ylabel('Iluminância');
title('Gráfico em Tempo Real - Iluminância');

subplot(2, 1, 2);
hUV = plot(dataUV);
xlabel('Amostras');
ylabel('Raios UV');
title('Gráfico em Tempo Real - Raios UV');

% Configura os eixos dos gráficos
axis([0 maxSamples 0 1023]);

% Inicializa a tabela
tabelaDados = table('Size', [maxSamples, 2], 'VariableTypes', double, 'VariableNames', {'Iluminancia', 'UV'});

% Loop para atualizar os gráficos e a tabela em tempo real
idx = 1; % Índice para controlar a posição atual nos vetores de dados
while ishandle(hIluminancia) && ishandle(hUV)
    % Lê os dados da porta serial
    dados = str2double(strsplit(fgetl(s), ',')); % Assume que os dados são separados por vírgula

    % Atualiza os vetores de dados
    dataIluminancia(idx) = dados(1); % Valor de iluminância
    dataUV(idx) = dados(2); % Valor de raios UV

    % Atualiza os gráficos
    set(hIluminancia, 'YData', dataIluminancia);
    set(hUV, 'YData', dataUV);
    drawnow;

    % Atualiza a tabela
    tabelaDados(idx, :) = array2table(dados, 'VariableNames', {'Iluminancia', 'UV'});

    % Atualiza o índice
    idx = idx + 1;
    if idx > maxSamples
        idx = 1; % Volta para o início quando o limite é atingido
    end
end

% Fecha a porta serial quando os gráficos são fechados
fclose(s);
delete(s);
clear s;