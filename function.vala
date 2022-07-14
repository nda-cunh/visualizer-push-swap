//valac main.vala function.vala --pkg=gtk+-3.0 --pkg=posix
 
void ra()
{
    int tmp = s_a.pop_head();
    s_a.push_tail(tmp);
}
void rra()
{
    int tmp = s_a.pop_tail();
    s_a.push_head(tmp);
}
void pb()
{
    int tmp = s_a.pop_head();
    s_b.push_head(tmp);
}
void pa()
{
    int tmp = s_b.pop_head();
    s_a.push_head(tmp);
}

void rb()
{
    int tmp = s_b.pop_head();
    s_b.push_tail(tmp);
}

void rrb()
{
    int tmp = s_b.pop_tail();
    s_b.push_head(tmp);
}

void rr()
{
    ra();
    rb();
}

void rrr()
{
    rra();
    rrb();
}

void sa()
{
    int tmp1 = s_a.pop_head();
    int tmp2 = s_a.pop_head();
    s_a.push_head(tmp1);
    s_a.push_head(tmp2);
}

void sb()
{
    int tmp1 = s_b.pop_head();
    int tmp2 = s_b.pop_head();
    s_b.push_head(tmp1);
    s_b.push_head(tmp2);
}
void ss()
{
    sa();
    sb();
}
