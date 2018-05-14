close all;
clc;
clear;

i=imread('img1_test.png');
j=imread('img1_test.png');

i=rgb2gray(i);
j=rgb2gray(j);


[h1_1, h2_1] = generate_hash(i, 'asdf1234');
[h1_2, h2_2] = generate_hash(j, 'asdf1234');

rez1=hammingdistance(h1_1,h1_2);
rez2=hammingdistance(h2_1,h2_2);