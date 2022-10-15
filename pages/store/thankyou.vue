<template>
    <div>
        <MainHeader />

        <main>
            <h2>Thank you</h2>

            <p>Thank you so much for allowing us to honor your baby in this way, or for supporting those of us in the loss community!</p>

            <p>For any ideas, questions, or concerns, please email us:</p>
            <a href="mailto:micayla@themarigoldproject.com">here</a>
        </main>

        <MainFooter />
    </div>
</template>
  
<style lang="scss" scoped>
    main {
        margin: 125px auto;
        flex-wrap: wrap;

        h2, p {
            width: 100%;
        }

        h2 {
            font-weight: 200;
            font-size: 48px;
        }

        p {
            font-size: 32px;
            font-weight: 200;
            margin: 0 0 16px 0;

            @media screen and (max-width: 768px) {
                font-size: 24px;
            }
        }

        a {
            width: 100%;
            font-size: 32px;
            font-weight: 400;
            text-decoration: underline;
            margin-top: -8px;

            @media screen and (max-width: 768px) {
                font-size: 24px;
            }
        }
    }
</style>
  