public void ra(Queue<int> s_a)
{
    int tmp = s_a.pop_head();
    s_a.push_tail(tmp);
}

public void rra(Queue<int> s_a)
{
    int tmp = s_a.pop_tail();
    s_a.push_head(tmp);
}

public void pb(Queue<int> s_a, Queue<int> s_b)
{
    int tmp = s_a.pop_head();
    s_b.push_head(tmp);
}

public void pa(Queue<int> s_a, Queue<int> s_b)
{
    int tmp = s_b.pop_head();
    s_a.push_head(tmp);
}

public void rb(Queue<int> s_b)
{
    int tmp = s_b.pop_head();
    s_b.push_tail(tmp);
}

public void rrb(Queue<int> s_b)
{
    int tmp = s_b.pop_tail();
    s_b.push_head(tmp);
}

public void rr(Queue<int> s_a, Queue<int> s_b)
{
    ra(s_a);
    rb(s_b);
}

public void rrr(Queue<int> s_a, Queue<int> s_b)
{
    rra(s_a);
    rrb(s_b);
}

public void sa(Queue<int> s_a)
{
    int tmp1 = s_a.pop_head();
    int tmp2 = s_a.pop_head();
    s_a.push_head(tmp1);
    s_a.push_head(tmp2);
}

public void sb(Queue<int> s_b)
{
    int tmp1 = s_b.pop_head();
    int tmp2 = s_b.pop_head();
    s_b.push_head(tmp1);
    s_b.push_head(tmp2);
}

public void ss(Queue<int> s_a, Queue<int> s_b)
{
    sa(s_a);
    sb(s_b);
}
