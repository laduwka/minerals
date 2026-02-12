---
layout: default
title: Home
page_scripts: [search]
---

# Mineral Collection Catalog

A personal catalog of minerals and rocks, organized by mineralogical classification.

## Browse by classification

- [Mineral classes](taxonomy/classes) — Dana/Strunz top-level categories
- [Groups and subclasses](taxonomy/groups) — finer divisions within each class
- [Glossary](taxonomy/glossary) — key terms (Mohs scale, luster, habit, crystal systems)

## Mineral index

<div class="search-bar">
  <input type="text" id="mineral-search" placeholder="Search minerals by name, class, or tags...">
</div>

{% assign minerals = site.pages | where: "layout", "mineral" | sort: "name" %}
{% assign classes = minerals | map: "mineral_class" | uniq | sort %}

<div class="filter-chips">
  <button class="filter-chip active" data-filter="all">All</button>
  {% for cls in classes %}
  <button class="filter-chip" data-filter="{{ cls | downcase }}">{{ cls }}</button>
  {% endfor %}
</div>

<div class="card-grid" id="mineral-grid">
  {% for mineral in minerals %}
    {% include mineral-card.html mineral=mineral %}
  {% endfor %}
  <p class="no-results" id="no-results" hidden>No minerals match your search.</p>
</div>
