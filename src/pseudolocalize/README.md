## PseudoLocalize
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

Pseudo localizes text. Useful for verifying translation without having actual translations available

## Installation
```
npm install @quenty/pseudolocalize --save
```

## Usage
Usage is designed to be simple.

### `PseudoLocalize.pseudoLocalize(line)`
Translates a line into pseudo text while maintaining params

### `PseudoLocalize.addToLocalizationTable(localizationTable, preferredLocaleId, preferredFromLocale)`
Parses a localization table and adds a pseudo localized locale to the table

