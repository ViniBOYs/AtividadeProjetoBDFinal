use formativahogwarts;
show tables;

create table editora(
	id bigint not null auto_increment,
    nome varchar(100) not null,
    gestor varchar(100) not null,
    unidadeFederativa enum('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO') not null,
    # decidi fazer por enum pq de qualquer forma eu iria ter que inserir as unidades individualmente e manualmente, por isso já coloquei aq, alem de ser algo que dificilmente irá mudar
    # a menos que a instituição saida do brasil (mas adicionar novas opções no enum n seria o maior do problemas q eles iriam ter kkkkkk)
    primary key(id)
);

create table livro(
	id bigint not null auto_increment,
    titulo varchar(100) not null,
    descricao varchar(500) not null,
    dataLancamento date not null,
    edicao int not null,
    editoraFK bigint not null,
    primary key(id),
    foreign key(editoraFK) references editora(id)
);

create table autor(
	id bigint not null auto_increment,
    nome varchar(200) not null,
    dataDeNasc date,
    contactEmail varchar(200) not null,
    primary key(id)
);

create table autorLivro(
	id bigint not null auto_increment,
    autorFK bigint not null,
    livroFK bigint not null,
    primary key(id),
    foreign key(autorFK) references autor(id),
    foreign key(livroFK) references livro(id)
);

create table emprestimoUser(
	id bigint not null auto_increment,
    usuarioFK bigint not null,
    funcionarioFK bigint not null,
    dataEmprestimo datetime not null default now(),
    dataDevolucao datetime not null,
    primary key(id),
    foreign key(usuarioFK) references usuarios(id),
    foreign key(funcionarioFK) references usuarios(id)
);
drop table emprestimouser;
create table emprestivoLivro(
	id bigint not null auto_increment,
    usuarioFK bigint not null,
    livroFK bigint not null,
    emprestimoIdFk bigint not null,
    dataDevolvida datetime,
    primary key(id),
    foreign key(usuarioFK) references usuarios(id),
    foreign key(livroFK) references livro(id),
    foreign key(emprestimoIdFk) references emprestimoUser(id)
);
select *from emprestivolivro;

############################################################
-- Insert de DADOS --
############################################################

insert into editora(nome, gestor, unidadeFederativa) values ('Academia de Letras','Pedro','SP'),('Educa Brasil','Ricarda','SP'),
('Editora Chico e cia','Chico','MG'),('Leitura é vida','Leandro','RJ'),('Amor em Ler','Julia','RJ');
select *from editora;

insert into autor (nome,contactEmail) values ('Marcelo Aciss','marcelinhoBruto@gmail.com'),
('Clara Rispectuor','claritaOficial@oul.com'),('Caique Dru Mont','DruMontContato@gmail.com'),
('Zé Alen Car','zezin_mail@gmail.com'),('Paolo Bunny','TheCarrotBunny@hotmail.com');
select *from autor;

insert into livro(titulo, descricao, datalancamento, edicao, editoraFK) values ('Uma boa vida','OO vida boa','2005-04-12',2,'1'),
('Corre Kderante','Não velozes nem furiosos','1998-06-07',6,'2'),('Nada se cria, tudo se copia','Nada além do que a mais pura verdade','1748-09-18',26,'3'),
('Não precisa preça, devagar chega','Perdendo o horario','1992-10-13',8,'4'),('Dá pra fazer drift de chevette?','Claro que sim','1975-09-11',2,'5'),
('Se colocar a mão vai queimar','Gelo tambem queima','2015-05-12',1,'1'),('Recuperação Do Andre','Quem quer passar estuda, pq o omi é bruto','2023-06-15',1,'2');
insert into livro(titulo, descricao, datalancamento, edicao, editoraFK) values ('Nova Pandemia Global?','Corona Virus é real?','2020-01-15','3°Edição','1');
select *from livro;

insert into autorLivro(autorFK, livroFK) values (1,3),(2,1),(3,6),(4,4),(4,5),(2,2),(5,7);

select *from autorLivro;

drop table autorlivro;
insert into ocupacao(titulo, nivelAcessoFK) values ('Bibliotecario',2);
insert into usuarios(nome, email, dataNascimento, senha, ocupacaoFK, status) values ('Jardir','JardirSesi389_2012@gmail.com','1989-03-12','SenhaForte','7',1);

select u.id, u.nome, o.titulo from usuarios u
join ocupacao o on u.id = o.id;

insert into emprestimoUser(usuarioFK, funcionarioFK,dataDevolucao) values (1,7,'2023-07-15'),(2,7,'2023-07-15'),(3,7,'2023-07-15'),(4,7,'2023-07-15'),
(1,7,'2023-07-25');

select *from emprestimoUser;    


select *from livro;
insert into emprestivoLivro(usuarioFK, livroFK, emprestimoIdFk) values (1,7,1),(2,1,2),(3,5,3);
insert into emprestivoLivro(usuarioFK, livroFK, emprestimoIdFk) values (1,5,1);
insert into emprestivoLivro(usuarioFK, livroFK, emprestimoIdFk, dataDevolvida) values (4,2,4,'2023-06-25 00:00:00'),(1,4,5,'2023-07-10');

select *from emprestivolivro;
#############################################
-- Selects --
#############################################

-- 1)

select eu.id, u.nome , e.nome as 'Funcionario', eu.dataEmprestimo, eu.dataDevolucao from emprestimouser eu
join usuarios u on u.id = eu.usuarioFK
join usuarios e on e.id = eu.funcionarioFK;

-- 2)

select (select count(*) from emprestimouser) as 'Total de Emprestimos', id, usuarioFK, dataEmprestimo, dataDevolucao from emprestimouser;



-- 3)
select titulo,descricao, edicao from livro
where edicao = (select min(edicao) from livro);


-- 4)

select a.nome, count(autorFK) as 'Qtd_Livros' from autorLivro al
join autor a on a.id = al.autorFK
group by autorFK order by Qtd_Livros desc;

-- 5)
#Não consigo colocar a condição e o group by junto, já tentei usar o having e o where e n vai de jeito nenhum

select el.id, u.nome, l.titulo, el.datadevolvida from emprestivolivro el
join usuarios u on u.id = el.usuarioFK
join livro l on l.id = el.livroFK
where el.datadevolvida is null;









###################################################################
# Algumas das minhas tentativas que não deram certo de fazer a 5

select u.nome, count(el.usuarioFK) as 'Qtd de livros Devidos'from emprestivolivro el
join usuarios u on u.id = el.usuarioFK
group by el.usuarioFK;

select count(emprestimoIdFk), usuarioFK, datadevolvida from emprestivolivro
group by usuarioFK
having dataDevolvida is null;

select * from emprestivolivro;









































