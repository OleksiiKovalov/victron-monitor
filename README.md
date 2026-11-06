# Victron GX Monitor

**[English](#english) · [Українська](#українська)**

---

## English

A one-file web dashboard for Victron GX devices on Venus OS (MultiPlus-II GX, Cerbo GX, …).
No cloud, no install, no internet: it talks to the GX over your local network.

Made for power outages. At a glance it answers two questions:

- **How long will the battery last** if the grid goes down right now?
- **How long will it take to charge** once the grid comes back?

And it lets you lower the input current or the charge current with one tap when the grid
(or a generator, or a stabilizer) is weak.

![Screenshot](docs/screenshot-en.png)

**What it shows**

- Battery charge, time to full and time to the reserve. The current mode shows actual
  figures; the other one shows a forecast for "if we switch now".
- Grid and inverter load in % with colour zones.
- Quick buttons for the input current limit and the charge current (the values are set in ⚙).
- Wall/tablet mode, grid-loss alerts, a 15-minute chart, and UA / EN.

> Written by Claude Code under the guidance of a human.
>
> *"Why do I need this? Can't I just vibe-code it myself?"*
> Of course you can. But why, if it's already done? All that's left is to open the page.

### Try it

Open `victron-monitor.html?demo=1` in a browser. The data are simulated and nothing is sent anywhere.

### Connect to your GX

1. On the GX, enable MQTT on LAN (plaintext):
   *Settings → Services* (newer firmware: *Settings → Integrations*) → *MQTT*.
2. Open `victron-monitor.html` on a computer in the same network.
3. In ⚙ Settings, enter the GX address `ws://<GX-IP>:9001` (or open `victron-monitor.html?host=<GX-IP>`).

### Phones and tablets: host the page on the GX

A file opened from a messenger can't reach your local network. Put the page on the GX instead:
it will open at `http://<GX-IP>/monitor/` on any device in the network and connect by itself.
The page survives firmware updates.

Once, on the GX: *Settings → General → Access level → Superuser*, set the root password, and turn on *SSH on LAN*.

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-to-gx.ps1 -Gx <GX-IP>
```

Linux / macOS:

```bash
scp victron-monitor.html install-monitor.sh root@<GX-IP>:/tmp/
ssh root@<GX-IP> 'mkdir -p /data/www/monitor && mv /tmp/victron-monitor.html /data/www/monitor/index.html && mv /tmp/install-monitor.sh /data/www/ && chmod 755 /data/www/install-monitor.sh && /data/www/install-monitor.sh'
```

To update, run the same command again.

### URL parameters

| Parameter | Meaning |
|---|---|
| `?host=192.168.1.50` | GX address |
| `?wall=1` | wall/tablet mode |
| `?lang=en` / `?lang=uk` | language |
| `?demo=1` | demo with simulated data |

### Caution

The limit buttons **write settings to your GX**. Know what you are changing; use at your own risk.
Tested on a MultiPlus-II GX 48/3000 with a Pylontech battery.
This is not a Victron Energy product and is not affiliated with Victron Energy.

### License

[MIT](LICENSE)

---

## Українська

Вебпанель в одному файлі для пристроїв Victron GX на Venus OS (MultiPlus-II GX, Cerbo GX, …).
Без хмари, без встановлення, без інтернету: працює з GX через локальну мережу.

Зроблено для відключень світла. Одним поглядом відповідає на два питання:

- **На скільки вистачить батареї**, якщо мережа зникне просто зараз?
- **Скільки часу знадобиться на заряд**, коли світло повернеться?

А ще дає одним дотиком зменшити вхідний струм або струм заряду, коли мережа
(чи генератор, чи стабілізатор) слабка.

![Скриншот](docs/screenshot-uk.png)

**Що показує**

- Заряд батареї, час до повного заряду і до резерву. Поточний режим показує фактичні
  цифри, інший — прогноз «якщо перемкнемося зараз».
- Навантаження мережі та інвертора у % з кольоровими зонами.
- Швидкі кнопки вхідного струму і струму заряду (значення задаються в ⚙).
- Настінний режим для планшета, сповіщення про зникнення мережі, графік за 15 хвилин, UA / EN.

> Написано Claude Code під керівництвом людини.
>
> *«А навіщо воно мені, я що, сам такого не навайбкоджу?»*
> Звісно, навайбкодиш. Але навіщо, якщо це вже зроблено? Залишилося просто відкрити сторінку.

### Спробувати

Відкрийте в браузері `victron-monitor.html?demo=1`. Дані симулюються, нікуди нічого не надсилається.

### Підключення до GX

1. На GX увімкніть MQTT у локальній мережі (plaintext):
   *Settings → Services* (у новій прошивці: *Settings → Integrations*) → *MQTT*.
2. Відкрийте `victron-monitor.html` на комп'ютері в тій самій мережі.
3. У ⚙ Налаштуваннях вкажіть адресу GX `ws://<IP-GX>:9001` (або відкрийте `victron-monitor.html?host=<IP-GX>`).

### Телефони й планшети: сторінка на самому GX

Файл, відкритий з месенджера, не бачить локальну мережу. Покладіть сторінку на GX:
вона відкриватиметься за адресою `http://<IP-GX>/monitor/` з будь-якого пристрою в мережі
й сама підключатиметься. Оновлення прошивки сторінку не видаляє.

Один раз на GX: *Settings → General → Access level → Superuser*, задайте пароль root і увімкніть *SSH on LAN*.

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-to-gx.ps1 -Gx <IP-GX>
```

Linux / macOS:

```bash
scp victron-monitor.html install-monitor.sh root@<IP-GX>:/tmp/
ssh root@<IP-GX> 'mkdir -p /data/www/monitor && mv /tmp/victron-monitor.html /data/www/monitor/index.html && mv /tmp/install-monitor.sh /data/www/ && chmod 755 /data/www/install-monitor.sh && /data/www/install-monitor.sh'
```

Щоб оновити, запустіть ту саму команду ще раз.

### Параметри адреси

| Параметр | Значення |
|---|---|
| `?host=192.168.1.50` | адреса GX |
| `?wall=1` | настінний режим |
| `?lang=uk` / `?lang=en` | мова |
| `?demo=1` | демо із симульованими даними |

### Обережно

Кнопки лімітів **записують налаштування у ваш GX**. Розумійте, що змінюєте; використовуйте на власний ризик.
Перевірено на MultiPlus-II GX 48/3000 з батареєю Pylontech.
Це не продукт Victron Energy і не пов'язано з Victron Energy.

### Ліцензія

[MIT](LICENSE)
