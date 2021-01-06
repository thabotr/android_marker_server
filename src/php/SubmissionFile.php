<?php


class SubmissionFile
{
    private int $submission_id;
    private int $file_id;

    public function __construct( int $submission_id, int $file_id)
    {
        $this->submission_id = $submission_id;
        $this->file_id = $file_id;
    }

    /**
     * @return int
     */
    public function getFileId(): int
    {
        return $this->file_id;
    }

    /**
     * @return int
     */
    public function getSubmissionId(): int
    {
        return $this->submission_id;
    }
}