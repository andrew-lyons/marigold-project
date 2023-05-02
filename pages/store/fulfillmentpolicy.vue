<template>
    <div>
        <MainHeader />

        <main>
            <h2>
                FULFILLMENT POLICY
            </h2>
            <p>
                Whenever you make a purchase or donation on our site, you will receive an email shortly afterward with your receipt of purchase and information about your purchase.
            </p>

            <p>
                All purchases and donations are carried out through Stripe.
            </p>

            <p>
                Please allow an appropriate amount of time for the email to be delivered. If you haven't received anything from us, make sure to check your Junk, Spam or Bulk Mail folder(s) to make sure it wasn't inadvertently kept out of your inbox.
            </p>
            
            <p>
                If your still haven't received an email from us within 30 minutes of purchase, you can send us an email <a href="mailto:micaylalyons@themarigoldproject.com">HERE</a>
            </p>
            <p>
                with "PURCHASE HELP" in the subject line. Make sure to include the name and email address submitted when making the purchase, as well as the name of the event for which you purchased a ticket.
                We'll do our best to get back to you as soon as possible.
            </p>
            
            <h3>Cancellations and refunds</h3>

            <p>
                The purpose of this site and these products displayed are for the sole purpose of enabling loss families and their friends to honor lost children. As such, we will do our best to work with you to ensure we can accomplish this together.

                <b>Cancellations</b>

                Should you find your ornament unsatisfactory, we encourage you to contact us so that we can fix the issue or offer another ornament to you. We will never ask you for more payments or donations--all proceeds go to non-profit organizations, we don't keep anything other than covering our cost of creating the pieces.

                <b>Refunds</b>

                Should you want your donation refunded, we will issue a refund no questions asked within 90 days of the initial donation. After this point, contact us directly so that we can work towards a solution together.
            </p>
        </main>

        <MainFooter />
    </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
    name: 'FulfillmentPolicy'
});
</script>

<style lang="scss" scoped>
main {
    margin-top: 24px;
    margin-bottom: 100px;
    flex-wrap: wrap;
    justify-content: center;
    
    p {
        text-align: left;
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        margin: 8px 0;

        a {
            font-size: 1.5rem;
            line-height: 1;
            margin-left: 8px;
        }

        b {
            width: 100%;
            margin: 8px 0 4px;
        }
    }
}
</style>
    
