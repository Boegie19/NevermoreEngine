## TextFilterUtils
<div align="center">
  <a href="http://quenty.github.io/api/">
    <img src="https://img.shields.io/badge/docs-website-green.svg" alt="Documentation" />
  </a>
  <a href="https://discord.gg/mhtGUS8">
    <img src="https://img.shields.io/badge/discord-nevermore-blue.svg" alt="Discord" />
  </a>
  <a href="https://github.com/Quenty/NevermoreEngine/actions">
    <img src="https://github.com/Quenty/NevermoreEngine/actions/workflows/build.yml/badge.svg" alt="Build and release status" />
  </a>
</div>

Utility functions for filtering text

## Installation
```
npm install @quenty/textfilterutils --save
```

## Usage
Usage is designed to be simple.

### `TextFilterUtils.promiseNonChatStringForBroadcast(str, fromUserId, textContext)`

### `TextFilterUtils.promiseLegacyChatFilter(playerFrom, text)`

### `TextFilterUtils.promiseNonChatStringForUserAsync(str, fromUserId, toUserId, textContext)`

### `TextFilterUtils.getNonChatStringForBroadcastAsync(str, fromUserId, textContext)`

### `TextFilterUtils.getNonChatStringForUserAsync(str, fromUserId, toUserId, textContext)`

### `TextFilterUtils._promiseTextResult(getResult, ...)`

