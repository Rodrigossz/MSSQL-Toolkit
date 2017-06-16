create table TipoScan (
id tinyint identity(1,1) primary key,
nome	tdDesc not null,
ativo	bit not null)
go

create table Agendamento (
id int identity(1,1) primary key,
acessoId int not null references Acesso,
dataHora smalldatetime not null,
dia tinyint,
mes tinyint,
ano smallint,
recorrente bit,
periodicidadeId tinyint references periodicidade)

create table Scan (
id int identity(1,1) primary key,
tipoScanId tinyint not null references tipoScan,
acessoId int not null references Acesso,
dataHora smalldatetime not null,
qtdVirus smallint default 0 not null,
firstScan bit default 0 not null,
logFirstScanId int null references LogFirstScan)

create table ScanArquivos (
id int identity(1,1) primary key,
scanId int not null references Scan,
nomeArquivo tddesc not null,
md5 tdSmallDesc not null,
limpou bit not null,
quarentena bit not null)


