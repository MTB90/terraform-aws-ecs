class TagRepo:
    """
    Repository for tags that encapsulate access to resources.
    """

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-tags')

    def add(self, name: str):
        """ Add tag to repository, if tag exist increment score

        :param name: Tag name
        """
        return self._tags.update_item(
            Key={'tag': name},
            UpdateExpression='ADD score :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW"
        )

    def list(self, limit=None):
        """List all elements that meet query and filter conditions.

        :param limit: Number of first tags
        """
        response = self._tags.scan()
        items = response['Items']
        items.sort(reverse=True, key=lambda x: x['score'])
        return items[0:limit]

