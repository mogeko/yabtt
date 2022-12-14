# Benchmark :100:

We used [Benchee](https://github.com/bencheeorg/benchee) as a framework to write a simple, (possibly) unscientific Benchmark.

## Defense

We pair **_`100` users_**, **_`1,000` users_** and **_`10,000` users_** with **_`100` BitTorrents_**, **_`1,000` BitTorrents_** and **_`10,000` BitTorrents_** one by one to form a **`3` &#215; `3` matrix**, and obtained a total of `9` groups of cases. Then use functions to randomly generate `Request` based on cases in each run to **imitate the performance of users of different sizes in accessing the server in different numbers of BitTorrents lists**.

```plaintext
     BitTorrent   BitTorrent    BitTorrent
User (100, 100)   (1000, 100)   (10000, 100)       Randomly generate `Request`
User (100, 1000)  (1000, 1000)  (10000, 1000)   -------------------------------->   &Benchee.run/2
User (100, 10000) (1000, 10000) (10000, 10000)
```

## Report

<details>
  <summary><b>System info</b></summary>
    <ul>
      <li>Elixir Version: 1.14.2</li>
      <li>Erlang Version: 25.2</li>
      <li>Operating system: Linux</li>
      <li>Available memory: 6.78 GB</li>
      <li>CPU Information: Intel(R) Xeon(R) Platinum 8272CL CPU @ 2.60GHz</li>
      <li>Number of Available Cores: 2</li>
    </ul>
</details>

<details>
  <summary><b>Environment variables</b></summary>
    <ul>
      <li>YABTT_QUERY_LIMIT: 30</li>
    </ul>
</details>

<details>
  <summary><b>Benchmark configuration</b></summary>
    <ul>
      <li>warmup: 2 s</li>
      <li>time: 5 s</li>
      <li>memory time: 0 ns</li>
      <li>reduction time: 0 ns</li>
      <li>reduction time: 0 ns</li>
      <li>parallel: 1</li>
    </ul>
</details>

### Large number of BitTorrents

| Name                     | Iterations per Second |   Average |    Deviation |    Median |                 Mode |   Minimum |     Maximum | Sample size |
| :----------------------- | --------------------: | --------: | -----------: | --------: | -------------------: | --------: | ----------: | ----------: |
| large number of users    |                1.53 K | 652.99 ??s | &#177;33.85% | 628.70 ??s | 645.40 ??s, 635.70 ??s | 419.50 ??s |  5584.01 ??s |        7617 |
| moderate number of users |                1.50 K | 664.84 ??s | &#177;37.05% | 629.50 ??s |            535.00 ??s | 409.90 ??s |  7383.41 ??s |        7480 |
| small number of users    |                1.01 K | 991.33 ??s | &#177;29.80% | 940.79 ??s | 824.90 ??s, 897.60 ??s | 671.00 ??s | 10153.44 ??s |        5025 |

<p align="center">
  <img alt="ips-1" src="https://user-images.githubusercontent.com/26341224/210154096-1596d17e-5522-4fd8-b933-cfc4e8871ec0.png" />
</p>

<p align="center">
  <img alt="run-time-1" src="https://user-images.githubusercontent.com/26341224/210154101-a9ba660d-1973-47a6-849c-099887c70f2a.png" />
</p>

### Medium number of BitTorrents

| Name                     | Iterations per Second |   Average |    Deviation |    Median |                                       Mode |   Minimum |     Maximum | Sample size |
| :----------------------- | --------------------: | --------: | -----------: | --------: | -----------------------------------------: | --------: | ----------: | ----------: |
| large number of users    |                1.88 K | 531.61 ??s | &#177;37.47% | 485.50 ??s |                                  493.90 ??s | 346.30 ??s |  5613.71 ??s |        9349 |
| moderate number of users |                1.87 K | 533.89 ??s | &#177;47.34% | 488.80 ??s |    443 ??s, 491.70 ??s, 417.20 ??s, 440.20 ??s | 345.90 ??s |  8931.21 ??s |        9307 |
| small number of users    |                1.32 K | 755.99 ??s | &#177;61.85% | 706.20 ??s | 634.60 ??s, 702.00 ??s, 832.80 ??s, 691.80 ??s | 518.50 ??s | 33562.44 ??s |        6582 |

<p align="center">
  <img alt="ips-2" src="https://user-images.githubusercontent.com/26341224/210154103-b17fe2cd-0edc-4203-b5b1-51c59e452a7c.png" />
</p>

<p align="center">
  <img alt="run-time-2" src="https://user-images.githubusercontent.com/26341224/210154104-b7940c6d-a47d-4d11-8e50-c21b27fa0b15.png" />
</p>

### Small amount of BitTorrent

| Name                     | Iterations per Second |   Average |    Deviation |    Median |                                                                                                                 Mode |   Minimum |    Maximum | Sample size |
| :----------------------- | --------------------: | --------: | -----------: | --------: | -------------------------------------------------------------------------------------------------------------------: | --------: | ---------: | ----------: |
| large number of users    |                1.91 K | 524.12 ??s | &#177;42.72% | 480.50 ??s | 445.70 ??s, 502.80 ??s, 491.60 ??s, 489.80 ??s, 449.40 ??s, 368.30 ??s, 498.50 ??s, 447 ??s, 503.10 ??s, 438.20 ??s, 498.70 ??s | 339.50 ??s | 6138.81 ??s |        9480 |
| moderate number of users |                1.83 K | 547.28 ??s | &#177;52.97% | 480.50 ??s |                                                                                                            483.80 ??s | 345.40 ??s | 6824.51 ??s |        9082 |
| small number of users    |                1.34 K | 744.98 ??s | &#177;31.50% | 707.30 ??s |                                                                                                            639.90 ??s |    517 ??s | 6809.51 ??s |        6680 |

<p align="center">
  <img alt="ips-3" src="https://user-images.githubusercontent.com/26341224/210154105-69e20e36-5401-4e8a-8afe-04f068396ac1.png" />
</p>

<p align="center">
  <img alt="run-time-3" src="https://user-images.githubusercontent.com/26341224/210154097-01cbe9c5-7832-4b02-b5fb-1d712304bf6f.png" />
</p>

> **Note** This report applies to application version [0.0.4](https://github.com/mogeko/yabtt/tree/a69b9ef10256091b58abf17b8b0147e5cca37332).
