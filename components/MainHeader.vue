<template>
    <div>
        <nav>
            <router-link to="/">Home</router-link>
            <router-link to="/about">About</router-link>
            <router-link to="/blog">Blog</router-link>
            <!-- <router-link to="/store">Store</router-link> -->
        </nav>
    
        <header>
            <h1>
                The Marigold Project
            </h1>
        </header>
    </div>
</template>

<style lang="scss" scoped>
nav {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 4;
    display: flex;
    justify-content: center;
    font-weight: 600;
    text-align: center;
    background: var(--white);
    text-transform: uppercase;
    letter-spacing: 5px;
    font-size: 12px;

    a {
        font-weight: 600;
        text-align: center;
        background: var(--white);
        text-transform: uppercase;
        letter-spacing: 5px;
        font-size: 12px;
        padding: 20px;
        text-decoration: none;

        &.router-link-exact-active {
            border-bottom: 1px solid var(--primary);
        }
    }
}

header {
    @media screen and (max-width: 768px) {
        margin-top: 50px;
    }

    h1 {
        display: inline-block;
        font-size: 7.15vw;
        font-weight: 100;
        letter-spacing: 5px;
        line-height: 2;
        margin-bottom: 10px;
        font-family: 'Montserrat', sans-serif;
        cursor: default;

        @media screen and (min-width: 1441px) {
            font-size: 103px;
        }

        @media screen and (max-width: 600px) {
            font-size: 64px;
            line-height: 72px;
            margin-bottom: 16px;
            padding: 0 16px;
        }
    }
}
</style>