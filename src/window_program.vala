
public bool reverse(string line, Queue<int> stackA, Queue<int> stackB)
{
	switch (line)
	{
		case "ra":
			rra(stackA);
			break;
		case "rra":
			ra(stackA);
			break;
		case "sa":
			sa(stackA);
			break;
		case "pa":
			pb(stackA, stackB);
			break;
		case "rb":
			rrb(stackB);
			break;
		case "rrb":
			rb(stackB);
			break;
		case "sb":
			sb(stackB);
			break;
		case "pb":
			pa(stackA, stackB);
			break;
		case "ss":
			ss(stackA, stackB);
			break;
		case "rr":
			rrr(stackA, stackB);
			break;
		case "rrr":
			rr(stackA, stackB);
			break;
		default:
			warning(line);
			return false;
	}
	return true;
}










public bool forward (string line, Queue<int> stackA, Queue<int> stackB)
{
	switch (line) {
		case "ra":
			ra(stackA);
			break;
		case "rra":
			rra(stackA);
			break;
		case "sa":
			sa(stackA);
			break;
		case "pa":
			pa(stackA, stackB);
			break;
		case "rb":
			rb(stackB);
			break;
		case "rrb":
			rrb(stackB);
			break;
		case "sb":
			sb(stackB);
			break;
		case "pb":
			pb(stackA, stackB);
			break;
		case "ss":
			ss(stackA, stackB);
			break;
		case "rr":
			rr(stackA, stackB);
			break;
		case "rrr":
			rrr(stackA, stackB);
			break;
		default:
			warning(line);
			return false;
	}
	return true;
}
