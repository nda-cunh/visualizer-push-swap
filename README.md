# VisualiZer

display your A and B stacks for the push_swap project at school 42

<img src="push_viz.gif"/>

## Installation  (No Suprapack)

```git clone https://gitlab.com/nda-cunh/visualizer-push-swap```

### dependency :
- gtk4
- (C-compiler) and valac

#### for 42 Angouleme or if you have valac dependency :

# With Shell script:
```bash
./install.sh
```

# With Meson build:
```bash
meson build --prefix=$PWD --bindir=''
ninja -C build install
```

## Installation  (With Suprapack)

```bash
suprapack install visualizer-pushswap
```

<br>

## how use it ???

it search your `push_swap` here:  `./push_swap`  or  `../push_swap`

```bash
./visualiser [1-1000]
```

please use `visualizer --help` 

<br>
<br>

# [ F.A.Q ]

Why my window is not in black-mode ?:
> you need change your gtk theme you can download it here: <br>
> https://www.pling.com/browse?cat=135

I don't understand why but my page is stuck when loading
> your push_swap is great in an infinite loop

I can't compile it ???
> install libgtk-4-dev and valac or use suprapack (package manager)



<br>
<br>


# Note
I also have a push_swap tester (linux)

https://github.com/nda-cunh/push_swap_tester
