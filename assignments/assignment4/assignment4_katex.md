# Assignment 4
tdattolo@iu.edu
b461

$$
1.\:\: \Pi_{W.cname}(worksfor \: W \bowtie _{p.pid=w.pid \wedge p.city='Bloomington \vee p.city='Indianapolis' } person \: P)
$$

$$
2.\:\: \Pi_{p.pid, p.name}(person\: p \bowtie _{p.pid=w.pid} workfor \: w \bowtie _{c.city='Bloomington'} company\:c)\\
\cap \Pi_{p1.pid, p1.name}(person \: p1 \bowtie _{p1.pid=k.pid1} knows k \bowtie _{p2.pid=k.pid2 \wedge p2.city='Chicago'}person\:p2)
$$

$$
3.\:\: \Pi_{j.skill}(jobskill \: j - (\sigma_{s.skill, w.cname='Yahoo'}(personskill \: s \bowtie _{s.pid=w.pid} worksfor \: w)
\cup (\sigma_{s.skill, w.cname='Netflix'}(personskill \: s \bowtie _{s.pid=w.pid} worksfor \: w)))
$$


$$
4.\:\: \Pi_{p.pid, p.name, p.pid\not ={p2.pid}}(person\:p \bowtie _{p.pid=k.kid} knows\:k \bowtie person\:p2 _{p2.pid=k.pid2 \wedge p2.birthYear>1985} \\
worksfor\:w \bowtie _{p2.pid=w.pid \wedge w.salary\ge55000 \wedge w.cname=c.cname \wedge c.cname='Netflix'} company\:c)
$$


$$
5.\:\: \Pi_{c1.cname, c2.cname}(company\:c1 \Join _{c1.cname \not ={c2.cname} \:\wedge\: c1.cname \notin (\sigma_{c.cname}(company\:c \: - \: \\
\Pi_{c3.cname, w.salary > (\sigma _{w2.salary, w2.cname=c2.cname}(worksfor\:w2))}(company\:c3 \Join _{c3.cname=w.cname} worksfor\:w)))})
$$

$$
6.\:\: \Pi_{p.pid,p.name}(person\:p \Join _{p.pid=k.pid1} knows\:k \Join _{p2.pid=k.pid2} person\:p2) - \\
\Pi_{p.pid,p.name}(person\:p \Join _{p.pid=k.pid1} knows\:k \Join _{p2.pid=k.pid2} person\:p2 \Join _{p2.pid=w.pid \wedge w.salary > 55000} worksfor\:w)
$$

   
$$
7.\:\: \Pi_{p.pid, w.salary \: < \: \Pi_{w.salary}(person\:p \Join _{p.pid=w.pid} \\ worksfor\:w \Join _{p.pid=s.pid \wedge s.skill='Accounting'})}(person\:p \Join _{p.pid=w.wid} worksfor\:w)
% \Pi_{w.salary}(person\:p \Join _{p.pid=w.pid} worksfor\:w \Join _{p.pid=s.pid \wedge s.skill='Accounting'})
$$


$$
8. \:\: \Pi_{c.cname \in\:(\sigma_{c2.cname}(company\:c2 \Join _{c2.cname=w2.cname\:\wedge\:w2.salary>50000\:\wedge\:c2.cname='IBM'}worksfor\:w2)), \\ p.pid\:\in\:(\sigma_{p2.pid}(person\:p2 \Join _{p2.pid=k.pid2} knows\:k \Join _{p2.pid=w.pid}worksfor\:w))}\\(company\:c \Join _{c.cname=w.cname}\: worksfor\:w \Join _{w.pid=p.pid\:\wedge\:w.cname='IBM'\:\wedge\:w.salary>50000} person\:p)
$$
