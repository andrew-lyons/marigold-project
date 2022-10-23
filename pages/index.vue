<template>
  <div style="overflow: hidden">
    <MainHeader />

    <HomeHero />
    <HomeDividerImageText />
    <HomeTripleImage />

    <MainFooter />
  </div>
</template>

<script setup>
import { onMounted } from 'vue';

onMounted(() => {
  console.log(this);

  const intersectionObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('io-visible');
      }
    })
  }, { threshold: 0.25 })

  document.querySelectorAll('main.ishome').forEach(el => intersectionObserver.observe(el));
})

</script>
