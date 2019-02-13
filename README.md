### Иллюстрация подхода ожидания завершения некоторых процессов через использование channel и join

#### Предположение

Ожидание через join дает большие задержки, тем больше, чем больше количество отслеживаемых процессов и выше вероятность ошибки. Это связано с тем, что в случае join, в худшем случае придется дождаться завершения всех процессов, в то время, как при использовании channel выход осуществляется немедленно, связано это с архитектурными ограничениями join.

#### Условие задачи

1. Для имитации работы запускается N файберов, каждый из которых засыпает на случайное время, но не более 1 секунды
2. С указанной вероятностью файбер вместо результата возвращает ошибку
3. При получении ошибки от любого из файберов итерация завершается

#### Запуск

```
tarantool ./bench.lua
```

#### Настройка

Смотри файл ```bench.lua```:

```
local workers = 100
local chance_of_error = 98
local iterations = 100
```

#### Прогон тестов на моей машине

```
workers:             10
chance of error, %:  98
iterations:          100
benchmarking of channel..
82.486378908157 seconds
benchmarking of join..
45.676003217697 seconds
```

```
workers:             10
chance of error, %:  50
iterations:          100
benchmarking of channel..
21.051764011383 seconds
benchmarking of join..
48.225121021271 seconds
```

```
workers:             100
chance of error, %:  98
iterations:          100
benchmarking of channel..
38.991818904877 seconds
benchmarking of join..
49.59193110466 seconds
```

```
workers:             100
chance of error, %:  50
iterations:          100
benchmarking of channel..
2.0956809520721 seconds
benchmarking of join..
49.59193110466 seconds
```

```
workers:             100
chance of error, %:  50
iterations:          100
benchmarking of channel..
2.0956809520721 seconds
benchmarking of join..
47.416046857834 seconds
```

#### Заключение

Реализация на join ожидаемо оказалась очень зависима от процента ошибок, но в ситуации с малым количеством ошибок и малым числом процессов быстрее реализации на channel.
