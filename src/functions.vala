/***********************************************************************
 * All push_swap instructions are defined here. 
 *
 * sa  : swap a - swap the first 2 elements at the top of stack a. Do nothing if there is only one or no elements).
 * sb  : swap b - swap the first 2 elements at the top of stack b. Do nothing if there is only one or no elements).
 * ss  : sa and sb at the same time.
 * pa  : push a - take the first element at the top of b and put it at the top of a. Do nothing if b is empty.
 * pb  : push b - take the first element at the top of a and put it at the top of b. Do nothing if a is empty.
 * ra  : rotate a - shift up all elements of stack a by 1. The first element becomes the last one.
 * rb  : rotate b - shift up all elements of stack b by 1. The first element becomes the last one.
 * rr  : ra and rb at the same time.
 * rra : reverse rotate a - shift down all elements of stack a by 1. The last element becomes the first one.
 * rrb : reverse rotate b - shift down all elements of stack b by 1. The last element becomes the first one.
 * rrr : rra and rrb at the same time.
 ***********************************************************************/ 

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
