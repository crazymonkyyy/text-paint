### textpainter

Quick and dirty tool to convert plaintext into markup.

Supports 32 tags across two layers, markup agnosist but probaly need some post processing, for example adding `<p>` for html

![screenrec001.gif](screenrec001.gif)
![keys.png](keys.png)

#### install

Depends on raylib and dmd

chmod +x biuld.d

./biuld.d txtfile markupdefination

#### markup defination

The markup defination is passed in as a 64 line file
```
1st forground tag opener
1st forground tag closer
2nd forground tag opener
...
16th forground tag closer
1st back ground tag opener
...
```

